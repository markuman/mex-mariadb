#include <my_global.h>
#include <mysql.h>
#include <mex.h>

char *hostname, *command, *password, *database, *username;
int port;
mxArray *cell_array_ptr;

#define CMOindex(r, c, rows) ( r + c * num_rows )

typedef enum {
    HOSTNAME,
    PORT,
    USERNAME,
    PASSWORD,
    DATABASE,
    COMMAND
} connection_details;

//#define DEBUG

void oh_boy(MYSQL *con){
    mexPrintf("oh boy >> %s\n", mysql_error(con));
    mysql_close(con);
    return;
}


void mexFunction (int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[]){
    // --- input checks
    // currently we need at least more than two inputs and one ouput!!
    // improve me!!
    if (nrhs != 6 && nlhs != 1) {
        mexErrMsgIdAndTxt( "MATLAB:mariadb:invalidNumInputs",
                        "Six inputs are required.");
    }

    // get hostname
    if ( mxIsChar(prhs[HOSTNAME]) ) {
        hostname = (char *) mxCalloc(mxGetN(prhs[HOSTNAME])+1, sizeof(char));
        mxGetString(prhs[HOSTNAME], hostname, mxGetN(prhs[HOSTNAME])+1);
        #ifdef DEBUG
        	mexPrintf("Hostname: %s\n", hostname);
        #endif
    } else {
        mexErrMsgIdAndTxt("MATLAB:mariadb:nrhs", "Error setting up mariadb connection: Hostname must be a string.");
    }

    // get port
    if ( mxIsDouble(prhs[PORT]) ) {
        // convert double to integer :: PORT
        double* data = mxGetPr(prhs[PORT]);
        port = (int)floor(data[0]);
        #ifdef DEBUG
        	mexPrintf("Port: %d\n", port);
        #endif
      } else {
        mexErrMsgIdAndTxt("MATLAB:mariadb:nrhs", "Error setting up mariadb connection: Port must be a double.");
    }

    // get username
        if ( mxIsChar(prhs[USERNAME]) ) {
        username = (char *) mxCalloc(mxGetN(prhs[USERNAME])+1, sizeof(char));
        mxGetString(prhs[USERNAME], username, mxGetN(prhs[USERNAME])+1);
        #ifdef DEBUG
        	mexPrintf("Username: %s\n", username);
        #endif
    } else {
        mexErrMsgIdAndTxt("MATLAB:mariadb:nrhs", "Error setting up mariadb connection: Username must be a string.");
    }

    // get password
    if ( mxIsChar(prhs[PASSWORD]) ) {
        password = (char *) mxCalloc(mxGetN(prhs[PASSWORD])+1, sizeof(char));
        mxGetString(prhs[PASSWORD], password, mxGetN(prhs[PASSWORD])+1);
        #ifdef DEBUG
        	mexPrintf("Password: %s\n", password);
        #endif
    } else {
        mexErrMsgIdAndTxt("MATLAB:mariadb:nrhs", "Error setting up mariadb connection: Password must be a string.");
    }

    // get username
    if ( mxIsChar(prhs[COMMAND]) ) {
        command = (char *) mxCalloc(mxGetN(prhs[COMMAND])+1, sizeof(char));
        mxGetString(prhs[COMMAND], command, mxGetN(prhs[COMMAND])+1);
        #ifdef DEBUG
        	mexPrintf("Command: %s\n", command);
        #endif
    } else {
        mexErrMsgIdAndTxt("MATLAB:mariadb:nrhs", "Error setting up mariadb connection: Command must be a string.");
    }

    // get databasename
    if ( mxIsChar(prhs[DATABASE]) ) {
        database = (char *) mxCalloc(mxGetN(prhs[DATABASE])+1, sizeof(char));
        mxGetString(prhs[DATABASE], database, mxGetN(prhs[DATABASE])+1);
        #ifdef DEBUG
        	mexPrintf("Database: %s\n", database);
        #endif
    } else {
        mexErrMsgIdAndTxt("MATLAB:mariadb:nrhs", "Error setting up mariadb connection: Database must be a string.");
    }

    MYSQL *con = mysql_init(NULL);

    if (con == NULL) {
        oh_boy(con);
        return;
    }

    if (mysql_real_connect(con, hostname, username, password, 
            database, port, NULL, 0) == NULL) {
        oh_boy(con);
        return;
    }  

    if (mysql_query(con, command)) {
        oh_boy(con);
        return;
    }

    MYSQL_RES *result = mysql_store_result(con);
    if (result == NULL) {
        oh_boy(con);
        return;
    }

    int num_fields = mysql_num_fields(result);
    #ifdef DEBUG
        mexPrintf("cols: %d\n", num_fields);
    #endif
    int num_rows = mysql_num_rows(result) + 1;
    #ifdef DEBUG
        mexPrintf("rows: %d\n", num_rows);
    #endif
    cell_array_ptr = mxCreateCellMatrix(num_rows, num_fields);
    MYSQL_ROW row;
    MYSQL_FIELD *field;
  
    int cell_index, r = 0;
    int get_head = 0;
    while ((row = mysql_fetch_row(result))) {
        for(int col = 0; col < num_fields; col++) {
            if (get_head == 0 && col == 0) {
                int c = 0;
                while(field = mysql_fetch_field(result)) {
                    cell_index = CMOindex(r, c, num_rows);
                    mxSetCell(cell_array_ptr, cell_index, mxCreateString(field->name));
                    c++;
                }
                get_head = 1;
                r++;
            }
            cell_index = CMOindex(r, col, num_rows);
            mxSetCell(cell_array_ptr, cell_index, mxCreateString(row[col] ? row[col] : "NULL"));
        }
        r++;
    }
  
    plhs[0] = cell_array_ptr;
    mysql_free_result(result);
    mysql_close(con);
    return;

}
