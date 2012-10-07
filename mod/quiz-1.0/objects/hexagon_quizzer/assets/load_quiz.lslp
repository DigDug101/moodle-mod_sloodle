//
// The line above should be left blank to avoid script errors in OpenSim.

/* load_quiz

    Copyright (c) 2006-9 Sloodle (various contributors)
    Released under the GNU GPL
    

    This files lists all the status codes we use for sloodle.
    They have been written in LSL format so that you can plunk them into your source
    code if needed. 

    Contributors:
    Edmund Edgar
    Paul Preibisch
    
   
     
*/
        integer SLOODLE_CHANNEL_ERROR_TRANSLATION_REQUEST=-1828374651;
        integer doRepeat = 0; // whether we should run through the questions again when we're done
        integer doDialog = 1; // whether we should ask the questions using dialog rather than chat
        integer doPlaySound = 1; // whether we should play sound
        integer doRandomize = 1; // whether we should ask the questions in random order
        string sloodleserverroot = "";
        integer sloodlecontrollerid = 0;
        string sloodlepwd = "";
        integer sloodlemoduleid = 0;
        list server_requests;
        integer sloodleobjectaccessleveluse = 0; // Who can use this object?
        integer sloodleobjectaccesslevelctrl = 0; // Who can control this object?
        integer sloodleserveraccesslevel = 0; // Who can use the server resource? (Value passed straight back to Moodle)
        integer isconfigured = FALSE; // Do we have all the configuration data we need?
        integer eof = FALSE; // Have we reached the end of the configuration data?
        integer SLOODLE_CHANNEL_AVATAR_DIALOG = 1001;
        integer SLOODLE_CHANNEL_OBJECT_DIALOG = -3857343; // an arbitrary channel the sloodle scripts will use to talk to each other. Doesn't atter what it is, as long as the same thing is set in the sloodle_slave script. 
        integer SLOODLE_CHANNEL_AVATAR_IGNORE = -1639279999;
        integer SLOODLE_CHANNEL_QUIZ_START_FOR_AVATAR = -1639271102; //Tells us to start a quiz for the avatar, if possible.; Ordinary quiz chair will have a second script that detects and avatar sitting      on it and sends it. Awards-integrated version waits for a game ID to be set before doing this.
        integer SLOODLE_CHANNEL_QUIZ_STARTED_FOR_AVATAR = -1639271103; //Sent by main quiz script to tell UI scripts that quiz has started for avatar with key
        integer SLOODLE_CHANNEL_QUIZ_COMPLETED_FOR_AVATAR = -1639271104; //Sent by main quiz script to tell UI scripts that quiz has finished for avatar with key, with x/y correct in string
        integer SLOODLE_CHANNEL_QUESTION_ASKED_AVATAR = -1639271105; //Sent by main quiz script to tell UI scripts that question has been asked to avatar with key. String contains question ID + "|" + question text
        integer SLOODLE_CHANNEL_QUESTION_ANSWERED_AVATAR = -1639271106;  //Sent by main quiz script to tell UI scripts that question has been answered by avatar with key. String contains selected option ID + "|" + option text + "|"
        integer SLOODLE_CHANNEL_QUIZ_LOADING_QUESTION = -1639271107; 
        integer SLOODLE_CHANNEL_QUIZ_LOADED_QUESTION = -1639271108;
        integer SLOODLE_CHANNEL_QUIZ_LOADING_QUIZ = -1639271109;
        integer SLOODLE_CHANNEL_QUIZ_LOADED_QUIZ = -1639271110;
        integer SLOODLE_CHANNEL_QUIZ_GO_TO_STARTING_POSITION = -1639271111;            
        integer SLOODLE_CHANNEL_QUIZ_ASK_QUESTION_CHAT = -1639271125; // Tells the question handler scripts to ask the question with the ID in str to the avatar with key VIA CHAT.
        integer SLOODLE_CHANNEL_QUIZ_ASK_QUESTION_TEXT_BOX=-1639277001;//asks via a text box
        integer SLOODLE_CHANNEL_QUIZ_ASK_QUESTION_DIALOG = -1639271126; // Tells the question handler scripts to ask the question with the ID in str to the avatar with key VIA DIALOG.
        integer SLOODLE_CHANNEL_ANSWER_SCORE_FOR_AVATAR = -1639271113; // Tells anyone who might be interested that we scored the answer. Score in string, avatar in key.
        integer SLOODLE_CHANNEL_QUIZ_STATE_ENTRY_DEFAULT = -1639271114; //mod quiz script is in state DEFAULT
        integer SLOODLE_CHANNEL_QUIZ_STATE_ENTRY_READY = -1639271115; //mod quiz script is in state READY
        integer SLOODLE_CHANNEL_QUIZ_STATE_ENTRY_LOAD_QUIZ_FOR_USER = -1639271116; //mod quiz script is in state CHECK_QUIZ
        integer SLOODLE_CHANNEL_QUIZ_STATE_ENTRY_QUIZZING = -1639271117; //mod quiz script is in state quizzing
        integer SLOODLE_CHANNEL_QUIZ_NO_PERMISSION_USE= -1639271118; //user has tried to use the chair but doesnt have permission to do so.
        integer SLOODLE_CHANNEL_QUIZ_STOP_FOR_AVATAR = -1639271119; //Tells us to STOP a quiz for the avatar
        integer SLOODLE_CHANNEL_QUIZ_SUCCESS_NOTHING_MORE_TO_DO_WITH_AVATAR= -1639271122;
        integer SLOODLE_CHANNEL_QUIZ_FAILURE_NOTHING_MORE_TO_DO_WITH_AVATAR= -1639271123;
        integer SLOODLE_CHANNEL_QUIZ_ERROR_INVALID_QUESION = -1639271121;  //
        integer SLOODLE_CHANNEL_QUIZ_ERROR_ATTEMPTS_LEFT= -1639271123;  //
        integer SLOODLE_CHANNEL_QUIZ_ERROR_NO_QUESTIONS= -1639271124;  //  
        integer SLOODLE_CHANNEL_QUIZ_FINISH_QUIZ=-1639277002;        
        integer SLOODLE_CHANNEL_QUIZ_LOAD_QUIZ= -1639277003;//user touched object
        list question_ids;
        ///// COLORS ////
        vector RED =<1.00000, 0.00000, 0.00000>;
        vector ORANGE=<1.00000, 0.43763, 0.02414>;
        vector YELLOW=<1.00000, 1.00000, 0.00000>;
        vector GREEN=<0.00000, 1.00000, 0.00000>;
        vector BLUE=<0.00000, 0.00000, 1.00000>;
        vector BABYBLUE=<0.00000, 1.00000, 1.00000>;
        vector PINK=<1.00000, 0.00000, 1.00000>;
        vector PURPLE=<0.57338, 0.25486, 1.00000>;
        vector BLACK= <0.00000, 0.00000, 0.00000>;
        vector WHITE= <1.00000, 1.00000, 1.00000>;
        ///// TRANSLATION /////
        // Link message channels
        integer SLOODLE_CHANNEL_TRANSLATION_REQUEST = -1928374651;
        // Translation output methods
        string SLOODLE_TRANSLATE_HOVER_TEXT = "hovertext";          // 2 output parameters: colour <r,g,b>, and alpha value
        string SLOODLE_TRANSLATE_WHISPER = "whisper";               // 1 output parameter: chat channel number
        string SLOODLE_TRANSLATE_SAY = "say";               // 1 output parameter: chat channel number
        string SLOODLE_TRANSLATE_OWNER_SAY = "ownersay";    // No output parameters
        string SLOODLE_TRANSLATE_DIALOG = "dialog";         // Recipient avatar should be identified in link message keyval. At least 2 output parameters: first the channel number for the dialog, and then 1 to 12 button label strings.
        string SLOODLE_TRANSLATE_LOAD_URL = "loadurl";      // Recipient avatar should be identified in link message keyval. 1 output parameter giving URL to load.
        string SLOODLE_TRANSLATE_IM = "instantmessage";     // Recipient avatar should be identified in link message keyval. No output parameters.
        integer SLOODLE_OBJECT_ACCESS_LEVEL_PUBLIC = 0;
        integer SLOODLE_OBJECT_ACCESS_LEVEL_OWNER = 1;
        integer SLOODLE_OBJECT_ACCESS_LEVEL_GROUP = 2;
        string SLOODLE_OBJECT_TYPE = "quiz-1.0";
        string SLOODLE_EOF = "sloodleeof";
        string sloodle_quiz_url = "/mod/sloodle/mod/quiz-1.0/linker.php";
        key httpquizquery = NULL_KEY;
        float request_timeout = 20.0;
        string sloodlehttpvars;
        // ID and name of the current quiz
        integer quizid = -1;
        string quizname = "";
        integer num_questions = 0;
        //quiz id
        integer quiz_id;
        string quiz_name;
         // Stores the number of questions the user got correct on a given attempt
       integer askquestionscontinuously=0;   
        integer correctToContinue=0; //must get question correct before next question is asked
        ///// FUNCTIONS /////
        debug (string message ){
              list params = llGetPrimitiveParams ([PRIM_MATERIAL ]);
              if ( llList2Integer (params ,0)==PRIM_MATERIAL_FLESH ){
                   llOwnerSay(llGetScriptName ()+": " +message );
             }
        }
        
        /******************************************************************************************************************************
        * sloodle_error_code - 
        * Author: Paul Preibisch
        * Description - This function sends a linked message on the SLOODLE_CHANNEL_ERROR_TRANSLATION_REQUEST channel
        * The error_messages script hears this, translates the status code and sends an instant message to the avuuid
        * Params: method - SLOODLE_TRANSLATE_SAY, SLOODLE_TRANSLATE_IM etc
        * Params:  avuuid - this is the avatar UUID to that an instant message with the translated error code will be sent to
        * Params: status code - the status code of the error as on our wiki: http://slisweb.sjsu.edu/sl/index.php/Sloodle_status_codes
        * Params: a message from the server to use if there is none listed in the linker script.        
        *******************************************************************************************************************************/
        sloodle_error_code(string method, key avuuid,integer statuscode, string msg){
            llMessageLinked(LINK_SET, SLOODLE_CHANNEL_ERROR_TRANSLATION_REQUEST, method+"|"+(string)avuuid+"|"+(string)statuscode+"|"+(string)msg, NULL_KEY);
        }   
        sloodle_debug(string msg){
            llMessageLinked(LINK_THIS, DEBUG_CHANNEL, msg, NULL_KEY);
        }  
          
        
        // Configure by receiving a linked message from another script in the object
        // Returns TRUE if the object has all the data it needs
        integer sloodle_handle_command(string str){
            list bits = llParseString2List(str,["|"],[]);
            integer numbits = llGetListLength(bits);
            string name = llList2String(bits,0);
            string value1 = "";
            string value2 = "";
            if (numbits > 1) value1 = llList2String(bits,1);
            if (numbits > 2) value2 = llList2String(bits,2);
            if (name == "set:sloodleserverroot") sloodleserverroot = value1;
            else if (name == "set:sloodlepwd") {
                // The password may be a single prim password, or a UUID and a password
                if (value2 != "") {
                   sloodlepwd = value1 + "|" + value2;
                }
                else {
                    sloodlepwd = value1;
                }
            }
            else if (name == "set:sloodlecontrollerid") sloodlecontrollerid = (integer)value1;
            else if (name == "set:sloodlemoduleid") sloodlemoduleid = (integer)value1;
            else if (name == "set:sloodleobjectaccessleveluse") sloodleobjectaccessleveluse = (integer)value1;
            else if (name == "set:sloodleserveraccesslevel") sloodleserveraccesslevel = (integer)value1;
            else if (name == "set:sloodlerepeat") doRepeat = (integer)value1;
            else if (name == "set:sloodlerandomize") doRandomize = (integer)value1;
            else if (name == "set:sloodledialog") doDialog = (integer)value1;
            else if (name == "set:sloodleplaysound") doPlaySound = (integer)value1;
            else if (name == "set:sloodleaskquestionscontinuously") askquestionscontinuously= (integer)value1;
            else if (name == "set:correctToContinue") correctToContinue = (integer)value1;
            else if (name == SLOODLE_EOF) eof = TRUE;
            
            return (sloodleserverroot != "" && sloodlepwd != "" && sloodlecontrollerid > 0 && sloodlemoduleid > 0);
        }
        
        // Send a translation request link message
        sloodle_translation_request(string output_method, list output_params, string string_name, list string_params, key keyval, string batch){
            llMessageLinked(LINK_THIS, SLOODLE_CHANNEL_TRANSLATION_REQUEST, output_method + "|" + llList2CSV(output_params) + "|" + string_name + "|" + llList2CSV(string_params) + "|" + batch, keyval);
        }
       default{
               on_rez(integer start_param) {
                   llResetScript();
               }
            state_entry(){
                isconfigured = FALSE;
                eof = FALSE;
                // Reset our configuration data
                sloodleserverroot = "";
                sloodlepwd = "";
                sloodlecontrollerid = 0;
                sloodlemoduleid = 0;
                sloodleobjectaccessleveluse = 0;
                sloodleserveraccesslevel = 0;
                doRepeat = 1;
                doDialog = 1;
                doPlaySound = 1;
                doRandomize = 1;
                //tell other scripts we are in the default state.
            }
            
            link_message( integer sender_num, integer num, string str, key id){
                // Check the channel for configuration messages
                if (num == SLOODLE_CHANNEL_OBJECT_DIALOG) {
                    // Split the message into lines
                    list lines = llParseString2List(str, ["\n"], []);
                    integer numlines = llGetListLength(lines);
                    integer i = 0;
                    for (i=0; i < numlines; i++) {
                        isconfigured = sloodle_handle_command(llList2String(lines, i));
                    }
                    // If we've got all our data AND reached the end of the configuration data (eof), then move on
                    if (eof == TRUE) {
                        if (isconfigured == TRUE) {
                            sloodle_translation_request(SLOODLE_TRANSLATE_SAY, [0], "configurationreceived", [], NULL_KEY, "");
                            state ready;
                        } else {
                            // Go all configuration but, it's not complete... request reconfiguration
                            sloodle_translation_request(SLOODLE_TRANSLATE_SAY, [0], "configdatamissing", [llGetScriptName()], NULL_KEY, "");
                            llMessageLinked(LINK_THIS, SLOODLE_CHANNEL_OBJECT_DIALOG, "do:reconfigure", NULL_KEY);
                            eof = FALSE;
                        }
                    }
                }
            }
        }
       state ready{
            on_rez(integer start_param) {
                   llResetScript();
               }
            state_entry(){
                sloodlehttpvars = "sloodlecontrollerid=" + (string)sloodlecontrollerid;
                sloodlehttpvars += "&sloodlepwd=" + sloodlepwd;
                sloodlehttpvars += "&sloodlemoduleid=" + (string)sloodlemoduleid;
                sloodlehttpvars += "&sloodleserveraccesslevel=" + (string)sloodleserveraccesslevel;
               
            }
            link_message(integer sender_num, integer num, string str, key user_key){
                if (num == SLOODLE_CHANNEL_QUIZ_LOAD_QUIZ) {
                    string body=sloodlehttpvars;
                    sloodle_translation_request(SLOODLE_TRANSLATE_IM, [0], "fetchingquiz",  [llKey2Name(user_key)], user_key, "quizzer");
                    // Request the quiz data from Moodle
                    body += "&sloodlerequestdesc="+"LOADING_QUIZ";
                    body += "&sloodleuuid=" + (string)user_key;
                    body += "&sloodleavname=" + llEscapeURL(llKey2Name(user_key));
                    body += "&request_timestamp="+(string)llGetUnixTime(); 
                    server_requests+= llHTTPRequest(sloodleserverroot + sloodle_quiz_url, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], body);
                    debug("loading quiz: "+sloodleserverroot + sloodle_quiz_url+"/?"+body);
                    
                }else
                if (num == SLOODLE_CHANNEL_OBJECT_DIALOG) {
                    // Is it a reset command?
                    if (str == "do:reset") {
                        llResetScript();
                    }
                    return;
                }
                  
            }   
            http_response(key request_id, integer status, list meta, string quiz_data){
                            /*
                                This response is a result of us calling load_quiz in the touch start event.  In load_quiz, we asked the server
                                for the quiz_name, and question_ids.  Now let's parse the data that was returned
                            */
                            // Is this the response we are expecting?
                            integer placeinlist=llListFindList(server_requests, [request_id]);        
                            if (placeinlist!=-1){
                                 
                                  server_requests= llDeleteSubList(server_requests, placeinlist, placeinlist);
                            }else {
                                  return;
                            }
                          
                            debug("quiz data: "+quiz_data);
                           
                           // Make sure the response was OK
                            if (status != 200) {
                                    sloodle_error_code(SLOODLE_TRANSLATE_SAY, NULL_KEY,status, ""); //send message to error_message.lsl
                                  //  llMessageLinked(LINK_SET, SLOODLE_CHANNEL_QUIZ_FAILURE_NOTHING_MORE_TO_DO_WITH_AVATAR, "", user_key);//todo add to dia
                                   
                            }
                            // Split the response into several lines
                            list lines = llParseString2List(quiz_data, ["\n"], []);
                            integer numlines = llGetListLength(lines);
                            quiz_data = "";
                            list statusfields = llParseStringKeepNulls(llList2String(lines,0), ["|"], []);
                            integer statuscode = (integer)llStringTrim(llList2String(statusfields, 0), STRING_TRIM);
                            key user_key = llList2Key(statusfields,6);
                            // Was it an error code?
                            if (statuscode == -10301) { 
                                sloodle_translation_request(SLOODLE_TRANSLATE_IM, [0], "noattemptsleft",  [llKey2Name(user_key)],user_key, "");
                              //  llMessageLinked(LINK_SET, SLOODLE_CHANNEL_QUIZ_FAILURE_NOTHING_MORE_TO_DO_WITH_AVATAR, "", user_key);//todo add to dia
                                return;
                                
                            } else if (statuscode == -10302) {
                                 sloodle_translation_request(SLOODLE_TRANSLATE_IM, [0], "noquestions",  [llKey2Name(user_key)],user_key, "quizzer");
                              //  llMessageLinked(LINK_SET, SLOODLE_CHANNEL_QUIZ_FAILURE_NOTHING_MORE_TO_DO_WITH_AVATAR, "", user_key);
                                return;
                                
                            } else if (statuscode <= 0) {
                                //sloodle_translation_request(SLOODLE_TRANSLATE_SAY, [0], "servererror", [statuscode], null_key, "");
                                string msg;
                                if (numlines > 1) {
                                    msg = llList2String(lines, 1);
                                }
                                sloodle_debug("quiz_data error: "+msg);
                                  //Sloodle 2.0 Change - output custom errorcode to other scripts
                                 sloodle_error_code(SLOODLE_TRANSLATE_IM, user_key,statuscode, msg); //send message to error_message.lsl                 
                             
                                return;
                            }
                            
                            // We shouldn't need the status line anymore... get rid of it
                            statusfields = [];
                    
                            // Go through each line of the response
                            integer i;
                            list question_ids_list;
                            for (i = 1; i < numlines; i++) {
                    
                                // Extract and parse the current line
                                string thislinestr = llList2String(lines, i);
                                list thisline = llParseString2List(thislinestr,["|"],[]);
                                string rowtype = llList2String( thisline, 0 ); 
                    
                                // Check what type of line this is
                                if ( rowtype == "quiz" ) {
                                    
                                    // Get the quiz ID and name
                                    quiz_id = (integer)llList2String(thisline, 4);
                                    quiz_name = llList2String(thisline, 2);
                                   
                                    //sloodle_translation_request(SLOODLE_TRANSLATE_HOVER_TEXT, [BLUE, 1.0], "quizname", [quiz_name], llGetOwner(), "quizzer");
                        
                                } else if ( rowtype == "quizpages" ) {
                                    
                                    // Extract the list of questions ID's
                                    
                                    question_ids_list = llCSV2List(llList2String(thisline, 3));
                                    num_questions = llGetListLength(question_ids_list);
                                    integer qiter = 0;
                                    question_ids = [];
                                    // Store all our question IDs
                                    for (qiter = 0; qiter < num_questions; qiter++) {
                                        question_ids += [(integer)llList2String(question_ids_list, qiter)];
                                    }
                                    
                                    // Are we to randomize the order of the questions?
                                    if (doRandomize) question_ids = llListRandomize(question_ids, 1);
                                   
                                }
                            }
                            string question_ids_str = llList2CSV(question_ids_list);
                            
                            // Make sure we have all the data we need
                            if (quiz_name == "" || num_questions == 0) {
                               
                                 sloodle_translation_request(SLOODLE_TRANSLATE_SAY, [0], "noquestions",  [llKey2Name(user_key)],user_key, "hex_quizzer");
                             //   llMessageLinked(LINK_SET, SLOODLE_CHANNEL_QUIZ_FAILURE_NOTHING_MORE_TO_DO_WITH_AVATAR, "", user_key);//add to dia
                            
                                return;
                            }
                            // Report the status to the user
                            sloodle_translation_request(SLOODLE_TRANSLATE_SAY, [0], "ready",  [llKey2Name(user_key)],user_key, "hex_quizzer");
                            llMessageLinked(LINK_SET, SLOODLE_CHANNEL_QUIZ_LOADED_QUIZ, (string)quiz_id+"|"+quiz_name+"|"+(string)num_questions+"|"+question_ids_str, user_key);
                        }             
        }
// Please leave the following line intact to show where the script lives in Git:
// SLOODLE LSL Script Git Location: mod/quiz-1.0/objects/multi_user_quiz/assets/load_quiz.lslp

