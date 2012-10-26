//
// The line above should be left blank to avoid script errors in OpenSim.

// LSL script generated: mod.set-1.0.rezzer_reset_btn.lslp Tue Nov 15 15:49:28 Tokyo Standard Time 2011
/*
*  Part of the Sloodle project (www.sloodle.org)
*
*  Copyright (c) 2011-06 contributors (see below)
*  Released under the GNU GPL v3
*  -------------------------------------------
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*  All scripts must maintain this copyrite information, including the contributer information listed
*
*  Contributors:
*  Paul Preibisch
*
*  DESCRIPTION
*  Rezzer.lslp
*  This script is responsible for:
*  *** initiating the loading of a quiz
*  *** getting the first question and loading the options as texture maps on the child prims (pie_slices)
*  *** initiating a countdown in the timer.lslp script
*  *** starting a sensor, and using hovertext to display which pie_slice a user is standing over
*  *** determining the value of each option and telling each pie_slice to open or close when the count down timer reaches zero 
*  *** determining which pie_slice a user is standing over at the end of the countdown, and submitting their answers to the notify_server.lslp script 
*  *** rezzing orbs on each of its edges which are clickable by avatars who answered correctly 
*  *** receive linked messages from the orbs which indicate touch events from avatars who have answered the question correctly, and rez 
*      rezzing child hexagons along the touched edges 
*  *** Receive GET QUESTION command from a child hex when its center orb has been touched by an avatar
*  *** requesting questions from question_handler.lslp and passing retrieved question along to the requesting child hexagon
*      
*
*/
float edge_length;
list QUESTIONS_ASKED;
float edge_length_half;
string CONFIG;
float tip_to_edge;
list rezzed_hexes;
list opids;
integer PIN=7961;
integer doRepeat;
integer doRandomize;
integer doPlaySound;
integer quiz_id;
string quiz_name;
integer question_id;
list question_ids;
integer num_questions;
integer current_question;
string sloodleserverroot = "";
integer sloodlecontrollerid = 0;
string sloodlepwd = "";
integer sloodlemoduleid = 0;
integer sloodleobjectaccessleveluse = 0; // Who can use this object?
integer sloodleobjectaccesslevelctrl = 0; // Who can control this object?
integer sloodleserveraccesslevel = 0; // Who can use the server resource? (Value passed straight back to Moodle)
integer isconfigured = FALSE; // Do we have all the configuration data we need?
integer eof = FALSE; // Have we reached the end of the configuration data?
string SLOODLE_EOF = "sloodleeof";
string sloodle_quiz_url = "/mod/sloodle/mod/quiz-1.0/linker.php";
list  sides_rezzed;
string QUIZ_DATA;
integer TIME_LIMIT;
list GRAND_CHILDREN;
integer SLOODLE_REMOTE_LOAD_SCRIPT=1639277018;
string HEX_CONFIG_SEPARATOR="*^*^*^";
integer SLOODLE_CHANNEL_ANIM= -1639277007;
integer SLOODLE_CHANNEL_OBJECT_DIALOG = -3857343; // an arbitrary channel the sloodle scripts will use to talk to each other. Doesn't atter what it is, as long as the same thing is set in the sloodle_slave script. 
integer SLOODLE_CHANNEL_ANSWER_SCORE_FOR_AVATAR = -1639271113; // Tells anyone who might be interested that we scored the answer. Score in string, avatar in key.
integer SLOODLE_SET_TEXTURE= -1639277010; 
integer SLOODLE_CHANNEL_QUIZ_MASTER_RESPONSE= -1639277008;
integer SLOODLE_CHANNEL_QUIZ_MASTER_REQUEST= -1639277006;
integer SLOODLE_CHANNEL_USER_TOUCH = -1639277002;//user touched object

integer SLOODLE_CHANNEL_QUIZ_LOADING_QUIZ = -1639271109;
string SLOODLE_TRANSLATE_HOVER_TEXT = "hovertext";          // 2 output parameters: colour <r,g,b>, and alpha value
string SLOODLE_TRANSLATE_WHISPER = "whisper";               // 1 output parameter: chat channel number
string SLOODLE_TRANSLATE_SAY = "say";               // 1 output parameter: chat channel number
string SLOODLE_TRANSLATE_OWNER_SAY = "ownersay";    // No output parameters
string SLOODLE_TRANSLATE_DIALOG = "dialog";         // Recipient avatar should be identified in link message keyval. At least 2 output parameters: first the channel number for the dialog, and then 1 to 12 button label strings.
string SLOODLE_TRANSLATE_LOAD_URL = "loadurl";      // Recipient avatar should be identified in link message keyval. 1 output parameter giving URL to load.
string SLOODLE_TRANSLATE_IM = "instantmessage";     // Recipient avatar should be identified in link message keyval. No output parameters.
integer SLOODLE_CHANNEL_TRANSLATION_REQUEST = -1928374651;
integer SLOODLE_CHANNEL_QUIZ_ASK_QUESTION = -1639271112; //used when this script wants to ask a question and have the results sent to the child hex
integer SLOODLE_CHANNEL_QUESTION_ASKED_AVATAR = -1639271105; //Sent by main quiz script to tell UI scripts that question has been asked to avatar with key. String contains question ID + "|" + question text
integer SLOODLE_CHANNEL_QUIZ_LOADED_QUIZ = -1639271110;
integer SLOODLE_CHANNEL_QUIZ_NOTIFY_SERVER_OF_RESPONSE= -1639277004;
integer SLOODLE_CHANNEL_QUIZ_STATE_ENTRY_LOAD_QUIZ_FOR_USER = -1639271116; //mod quiz script is in state CHECK_QUIZ
integer SLOODLE_TRANSLATE_HOVER_TEXT_LINKED_PRIM= -1639277009; // 3 output parameters: colour <r,g,b>,  alpha value, link number
string HEXAGON_PLATFORM="Hexagon Platform";
integer TIMES_UP=FALSE;
integer num_options=0;
list CORRECT_AVATARS;
list options;//store pie slice correlation. Therefore option[0]=pie_slice# 
integer quiz_loaded=FALSE;
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
vector AVCLASSBLUE= <0.06274,0.247058,0.35294>;
vector AVCLASSLIGHTBLUG=<0.8549,0.9372,0.9686>;//#daeff7
integer SLOODLE_TIMER_START= -1639277011; //shoudl be used to starts the timer from its current position
integer SLOODLE_TIMER_RESTART= -1639277012;//should be used to set the counter to 0 and begin counting down again
integer SLOODLE_TIMER_STOP= -1639277013;//should stop the timer at its current position
integer SLOODLE_TIMER_STOP_AND_RESET= -1639277014;//should stop the timer at its current position and reset count to 0
integer SLOODLE_TIMER_RESET= -1639277015;//shoudl reset the count back to zero but not restart the timer
integer SLOODLE_TIMER_TIMES_UP= -1639277016;//used to transmit the timer reached its time limit
list MY_SLICES;
integer already_received_question=FALSE;
integer my_start_param;
list pie_slice_hover_text;
string qdialogtext;
list qdialogoptions;
list option_points;
debug (string message ){
     list params = llGetPrimitiveParams ([PRIM_MATERIAL ]);
     if (llList2Integer (params ,0)==PRIM_MATERIAL_FLESH){
           llOwnerSay("memory: "+(string)llGetFreeMemory()+" Script name: "+llGetScriptName ()+": " +message );
     }
} 

//rezzes a hexagon at the indicated orb#
rez_hexagon(integer orb){
    if (llGetListLength(QUESTIONS_ASKED)>=num_questions){
        //quiz finished
        sloodle_translation_request(SLOODLE_TRANSLATE_SAY, [0], "no_more_questions", [], NULL_KEY, "hex_quizzer");
        return;
     }
     integer my_oposite_section;
     vector my_coord= llGetPos();
     if (orb==0){
         return;
     }
     float adjustment_x = 0.0402;
     float adjustment_y = -0.0365;
     vector child_coord=my_coord;
     integer DIVISER=1;
     if (orb==1){//yellow
        child_coord.x=my_coord.x + edge_length + edge_length/2;
        child_coord.y=my_coord.y -tip_to_edge;  
        my_oposite_section=4;                              
     }else
     if (orb==2){//pink
        child_coord.x=my_coord.x;
        child_coord.y=my_coord.y-tip_to_edge * 2;  
        my_oposite_section=5;
     }else
     if (orb==3){
        child_coord.x=my_coord.x - edge_length- edge_length/2;
        child_coord.y=my_coord.y - tip_to_edge; 
        my_oposite_section=6;
     }else
     if (orb==4){
        child_coord.y=my_coord.y+tip_to_edge;   
        child_coord.x=my_coord.x-edge_length-edge_length/2;
        my_oposite_section=1;
     }else 
     if (orb==5){
        child_coord.x=my_coord.x;
        child_coord.y=my_coord.y+ tip_to_edge * 2; 
        my_oposite_section=2;
     }else
     if (orb==6){
        child_coord.x=my_coord.x+ edge_length+edge_length/2;
        child_coord.y=my_coord.y+tip_to_edge; 
        my_oposite_section=3;
     }
    // child_coord.x=child_coord.x+ adjustment_x;
    // child_coord.y=child_coord.y+ adjustment_y;
    //rez a new hexagon, and pass my_oppsosite_section as the start_parameter so that the new hexagon wont rez on that the my_oposite_section edge
    llRezAtRoot(HEXAGON_PLATFORM, child_coord, ZERO_VECTOR,  llGetRot(), my_oposite_section);
}
set_all_pie_slice_hover_text(string msg){
    pie_slice_hover_text=[];
    pie_slice_hover_text+=" ";
    integer pie_slice_num;
     for (pie_slice_num=1;pie_slice_num<=6;pie_slice_num++){
         sloodle_translation_request("SLOODLE_TRANSLATE_HOVER_TEXT_LINKED_PRIM", [ORANGE, 1.0,get_prim("option"+(string)pie_slice_num)], "option", [msg], "", "hex_quizzer");
         pie_slice_hover_text+=msg;
     }
}
//returns the pie_slice the avatar is standing near
string get_detected_pie_slice(vector avatar){
    //returns name of pie_slice
    integer i;
    float closest_orb_distance=100.0;
    string  name_of_closest_orb="";
    integer closest_orb_link_number;
    integer root_orb= get_prim("Hexagon Quizzer");
    for (i=1;i<=6;i++){
        integer orb_link_number = get_prim("orb"+(string)i);
        list orb_data=llGetLinkPrimitiveParams(orb_link_number, [PRIM_POSITION]);
        
        vector orb_pos = llList2Vector(orb_data, 0);
        float detected_distance_from_avatar_to_orb = llVecDist(orb_pos, avatar);
        if (detected_distance_from_avatar_to_orb<closest_orb_distance){
            closest_orb_distance = detected_distance_from_avatar_to_orb;
            name_of_closest_orb="orb"+(string)i;
        }
    }
    
    return name_of_closest_orb;
}

display_questions_for_mother_hex(string str,key id){
                llTriggerSound("SND_LOADING_COMPLETE", 1);
                list data= llParseString2List(str, ["|"], []);
                string qdialogtext = llList2String(data,0);
                qdialogtext = strReplace(llList2String(data,0), ",", "*%*%*");
                key hex = llList2Key(data,1);
                list qdialogoptions= llParseString2List(llList2String(data,2), [","], []);
                option_points= llParseString2List(llList2String(data,3), [","], []);
                debug("---------------received question! str: "+str+"\nqdialogtext: "+qdialogtext+"\nhex: "+(string)hex+"\nqdialogoptions: "+llList2CSV(qdialogoptions)+"\noptionpoints: "+llList2CSV(option_points));
                sloodle_translation_request("SLOODLE_TRANSLATE_HOVER_TEXT_LINKED_PRIM", [ORANGE, 1.0,get_prim("question_prim")], "option", [qdialogtext], "", "hex_quizzer");
                key user_key=id;
                integer j=0;
                //set the hover text of the pie_slices to the questions options
                num_options=llGetListLength(qdialogoptions); 
                options=[];
                set_texture_pie_slices("blank_white");
                for (j=0;j<num_options;j++){
                     string pie_slice=llStringTrim(llList2String(MY_SLICES,j),STRING_TRIM);
                     string option = llList2String(qdialogoptions,j);
                     options+=pie_slice;//opid has already been stored
                    //SET PIE_SLICE TO PARTICULAR OPTION
                     set_texture_pie_slice((string)option,(integer)pie_slice);
                }
                debug("\n\n\n\n\n time limit is: "+(string)TIME_LIMIT);
                llMessageLinked(LINK_SET, SLOODLE_TIMER_RESTART, (string)TIME_LIMIT+"|SND_BUZZER", "");
               /* for (j=1;j<=6;j++){
                    integer value = pie_slice_value(j);
                    integer prim_link=get_prim("pie_slice"+(string)j);
                    sloodle_translation_request("SLOODLE_TRANSLATE_HOVER_TEXT_LINKED_PRIM", [YELLOW, 1.0,prim_link], "option", [value], "", "hex_quizzer");
                    debug("value for "+"pie_slice"+(string)j+" is: "+(string)value);
                }*/
                
}

integer pie_slice_option_index(integer pie_slice){
    integer option_index = llListFindList(options, [pie_slice]);
    integer index;
    if (option_index==-1){//here the user is standing on a pie_slice that did not even have a number printed on it, so give them a 0 for incorrect 
        index=-1;
    }else{//ok, good, the pie_slice they are standing on actually has a grade assigned to it
        //find how many points the pie_slice is worth  
        index = llList2Integer(opids,option_index);           
    }
    return index;
}
/*
*  This function will determine how much a particular pie_slice is worth. 
*
*
*/
integer pie_slice_value(integer pie_slice){
    /*
    * ex. check_correct(pie_slice6)
    * here a the program is searching to see if pie_slice 6 is in the options list.
    * If it is, find out which option it is. the index of this list is the actual option id.
    * We can use the option id (option index) to find out if it is worth any points, by examining the options_points list
    */    
    integer option_index = llListFindList(options, [pie_slice]);
    integer grade;
    if (option_index==-1){//here the user is standing on a pie_slice that did not even have a number printed on it, so give them a 0 for incorrect 
        grade=-1;
    }else{//ok, good, the pie_slice they are standing on actually has a grade assigned to it
        //find how many points the pie_slice is worth  
        grade = llList2Integer(option_points,option_index);           
    }
    return grade;
}
set_texture_pie_slices(string texture){
            //clear the rest of the prims
            integer j;
            for (j=1;j<=6;j++){
                integer face=4;
                if (j==1||j==2||j==3){
                    face = 1;
                }
                llMessageLinked(LINK_SET, SLOODLE_SET_TEXTURE, "pie_slice"+(string)j+"|"+(string)face+"|"+texture,NULL_KEY);
            }

} 
set_texture_pie_slice(string texture,integer pie_slice){
            //clear the rest of the prims
            integer face=4;
            if (pie_slice==1||pie_slice==2||pie_slice==3){
                face = 1;
            }
            
            debug("sending message on "+(string)SLOODLE_SET_TEXTURE+" "+ "pie_slice"+llStringTrim((string)pie_slice,STRING_TRIM)+"|"+(string)face+"|"+llStringTrim(texture,STRING_TRIM));
            llMessageLinked(LINK_SET, SLOODLE_SET_TEXTURE, "pie_slice"+llStringTrim((string)pie_slice,STRING_TRIM)+"|"+(string)face+"|"+llStringTrim(texture,STRING_TRIM),NULL_KEY);
            

}
integer question_prim;
integer num_links;
set_prim_text(integer prim,string text,vector color){
    llSetLinkPrimitiveParamsFast(prim, [PRIM_TEXT,text,color,1] );
}
/*
Search through all linked prims, and returns the prims link number which matches the name
*/
integer get_prim(string name){
    num_links=llGetNumberOfPrims();
    integer i;
    integer prim=-1;
    for (i=0;i<=num_links;i++){
        if (llGetLinkName(i)==name){
            prim=i;
        }else{
        }
    }
    return prim;
}
string strReplace(string str, string search, string replace) {
    return llDumpList2String(llParseStringKeepNulls(str, [search], []), replace);
}
// Send a translation request link message
sloodle_translation_request(string output_method, list output_params, string string_name, list string_params, key keyval, string batch){
    llMessageLinked(LINK_THIS, SLOODLE_CHANNEL_TRANSLATION_REQUEST, output_method + "|" + llList2CSV(output_params) + "|" + string_name + "|" + llList2CSV(string_params) + "|" + batch, keyval);
}
        
init(){
        current_question=0;
        MY_SLICES=[1,2,3,4,5,6];
        MY_SLICES=llListRandomize(MY_SLICES, 1);//randomize list of pie slices so we can dont display the question options over the same pie_slices each time
        //get the dimensions of a pie_slice so we can determin the length of the sides of a pieslice.  In this case, we will choose pie_slice6 (they all have same dimensions)
        integer pie_slice6 = get_prim("pie_slice6");
        list pie_slice_data = llGetLinkPrimitiveParams(pie_slice6, [PRIM_SIZE] );
        vector pie_slice_size=llList2Vector(pie_slice_data, 0);
        tip_to_edge = pie_slice_size.z;//since we are looking for the length starting from the tip of the pie_slice to the middle of the edge, we need to choose the z dimension for this particular pie slice
        edge_length= pie_slice_size.y;//since we are looking for  the length of an edge we need to choose the y dimension for this particular pie slice
        question_prim= get_prim("question_prim");
        sloodle_translation_request("SLOODLE_TRANSLATE_HOVER_TEXT_LINKED_PRIM", [YELLOW, 1.0,question_prim], "initquiz", [], "", "hex_quizzer");
        set_texture_pie_slices("blank_white");
        integer num_prims = llGetNumberOfPrims();
        integer i=0;
        //clear text
        for (i=0;i<num_prims;i++){
            sloodle_translation_request("SLOODLE_TRANSLATE_HOVER_TEXT_LINKED_PRIM", [GREEN, 1.0,i], "clear", [" "], "", "hex_quizzer");
        }
        for (i=0;i<=6;i++){
            pie_slice_hover_text+=" ";//this list will save the text for each orb
        }
            
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
            else if (name == "set:questiontimelimit"){
                 TIME_LIMIT= (integer)value1;
                   debug("\n\n\n\n\n we got time limit is: "+(string)TIME_LIMIT);
            }
            else if (name == "set:sloodlecontrollerid") sloodlecontrollerid = (integer)value1;
            else if (name == "set:sloodlemoduleid") sloodlemoduleid = (integer)value1;
            else if (name == "set:sloodleobjectaccessleveluse") sloodleobjectaccessleveluse = (integer)value1;
            else if (name == "set:sloodleserveraccesslevel") sloodleserveraccesslevel = (integer)value1;
            else if (name == "set:sloodlerepeat") doRepeat = (integer)value1;
            else if (name == "set:sloodlerandomize") doRandomize = (integer)value1;
            else if (name == "set:sloodleplaysound") doPlaySound = (integer)value1;
            else if (name == SLOODLE_EOF) eof = TRUE;
            return (sloodleserverroot != "" && sloodlepwd != "" && sloodlecontrollerid > 0 && sloodlemoduleid > 0);
       }

default {
    on_rez(integer start_param){
        llResetScript();
    }
    state_entry() {
        integer n=llGetNumberOfPrims();
        integer j=0;
        for (j=0;j<n;j++){
            llSetLinkPrimitiveParamsFast( j,[PRIM_TEXT," ",GREEN,1]);
        }
        llSetScriptState( "rezzer_platform.lslp", FALSE);
    }
    link_message(integer sender_num, integer num, string str, key id) {
        if (num==SLOODLE_CHANNEL_OBJECT_DIALOG){
            CONFIG=str;
            list lines = llParseString2List(CONFIG, ["\n"], []);
                    integer numlines = llGetListLength(lines);
                    integer i = 0;
                    for (i=0; i < numlines; i++) {
                        isconfigured = sloodle_handle_command(llList2String(lines, i));
                    }
                    // If we've got all our data AND reached the end of the configuration data (eof), then move on
                    if (eof == TRUE) {
                        if (isconfigured == TRUE) {
                               sloodle_translation_request ( SLOODLE_TRANSLATE_SAY , [0], "script_configurationreceived" , [ llGetScriptName()], NULL_KEY , "hex_quizzer");
                            state ready;
                        }
                    }
        }
    }
}
state ready{
        on_rez(integer start_param){
            llResetScript();
        }
        state_entry() {
          init();
          llTriggerSound("SND_STARTING_UP", 1);
          sloodle_translation_request("SLOODLE_TRANSLATE_HOVER_TEXT_LINKED_PRIM", [GREEN, 1.0,question_prim], "ready_click_colored_orb", [], "", "hex_quizzer");
          string name=llGetObjectName();
          //show orbs
          llMessageLinked(LINK_SET, SLOODLE_CHANNEL_ANIM, "orb hide|0,1,2,3,4,5,6|10", NULL_KEY);
              
        }
        touch_start(integer num_detected) {
            if (quiz_loaded==FALSE){
                sloodle_translation_request("SLOODLE_TRANSLATE_HOVER_TEXT_LINKED_PRIM", [ORANGE, 1.0,get_prim("question_prim")], "loading_question", [qdialogtext], "", "hex_quizzer");
                llMessageLinked(LINK_SET, SLOODLE_CHANNEL_QUIZ_STATE_ENTRY_LOAD_QUIZ_FOR_USER, "", llDetectedKey(0));
            }else{
                if (TIMES_UP){
                    TIMES_UP=FALSE;
                    set_all_pie_slice_hover_text(" ");
                    llSensorRepeat("", "", AGENT, edge_length, TWO_PI, 1);
                    llMessageLinked(LINK_SET, SLOODLE_TIMER_RESTART, (string)TIME_LIMIT+"|SND_BUZZER", "");
                }
            }
                    
        
        }
      
    link_message(integer link_set, integer channel, string str, key id) {
          list data= llParseString2List(str, ["|"], []);
        if (channel == SLOODLE_CHANNEL_OBJECT_DIALOG) {
                    // Split the message into lines
                    CONFIG = str;
        }
        if (channel==SLOODLE_CHANNEL_QUIZ_LOADED_QUIZ){
              QUIZ_DATA = str;
              data = llParseString2List(str, ["|"], []);
              quiz_id=llList2Integer(data,0);
              quiz_name=llList2String(data,1);
              num_questions=llList2Integer(data,2);
              question_ids=llParseString2List(llList2String(data,3), [","], []);
              debug("------quiz loaded: "+(string)quiz_id+" quiz name: "+quiz_name+" num questions: "+(string)num_questions);
        }else
        if (channel ==SLOODLE_CHANNEL_USER_TOUCH){
          
            string type = llList2String(data,0);
            //this is a rez edge attempt
            if (type!="orb"){
                 return;
            }
            if (type=="orb"){
                // a user touched an edge selector, so rez an edge                 
                integer orb=llList2Integer(data, 1);                
                rez_hexagon(orb);
                //after a user presses an edge selector, hide the selector
                llMessageLinked(LINK_SET, SLOODLE_CHANNEL_ANIM, "orb hide|"+(string)orb, NULL_KEY);
            }            
        }else 
        if (channel==SLOODLE_CHANNEL_QUESTION_ASKED_AVATAR){
            key hex = llList2Key(data,1);
            
            debug("SLOODLE_CHANNEL_QUESTION_ASKED_AVATAR");
            opids=llParseString2List(llList2String(data,6),[","],[]);
            if (hex==llGetKey()){
                question_id =llList2Integer(data,5);
                if (llListFindList(QUESTIONS_ASKED, [question_id])==-1){
                    QUESTIONS_ASKED+=question_id;
                }  
                
                quiz_loaded=TRUE;
                display_questions_for_mother_hex(str,id);
                llSensorRepeat("", "", AGENT, edge_length, TWO_PI, 1);
            }else{
                //send question to child hex
                if (llListFindList(rezzed_hexes, [hex])!=-1){
                    llRegionSayTo(hex,SLOODLE_CHANNEL_QUIZ_MASTER_RESPONSE, "receive question|"+str);
                }
            }
        }else
        if (channel==SLOODLE_TIMER_TIMES_UP){
            TIMES_UP=TRUE;
            
        }
    }
    sensor(integer num_avatars_detected) {
        if (!TIMES_UP){
            //go through each detected avatar and add their names to the prims they are standing in
            set_all_pie_slice_hover_text(" ");
            integer avatar;
            integer pie_slice_num;
            for (avatar=0;avatar<num_avatars_detected;avatar++){
                string avatar_name=llDetectedName(avatar);
                vector avatar_pos=llDetectedPos(avatar);
                string pie_slice = get_detected_pie_slice(avatar_pos);
                pie_slice_num=(integer)llGetSubString(pie_slice, -1, -1);
                string pie_slice_text =llList2String(pie_slice_hover_text,pie_slice_num);
                pie_slice_hover_text= llListReplaceList(pie_slice_hover_text, [pie_slice_text+"\n"+avatar_name], pie_slice_num, pie_slice_num);
            }
            //print names on pie slice hover text
            string avatar_names;
            for (pie_slice_num=1;pie_slice_num<=6;pie_slice_num++){
                    avatar_names=llList2String(pie_slice_hover_text,pie_slice_num);
                    sloodle_translation_request("SLOODLE_TRANSLATE_HOVER_TEXT_LINKED_PRIM", [YELLOW, 1.0,get_prim("option"+(string)pie_slice_num)], "option", [avatar_names], "", "hex_quizzer");
            }
        }else{
        	llTriggerSound("SND_BUZZER", 1);
            //gets triggered when after a countdown and time is up
             llSensorRemove();
             //go through each detected avatar and add their names to the prims they are standing in
            set_all_pie_slice_hover_text(" ");
            integer avatar;
            integer pie_slice_num;
            for (avatar=0;avatar<num_avatars_detected;avatar++){
                string avatar_name=llDetectedName(avatar);
                key  avatar_key=llDetectedKey(avatar);
                vector avatar_pos=llDetectedPos(avatar);
                string pie_slice = get_detected_pie_slice(avatar_pos);
                pie_slice_num=(integer)llGetSubString(pie_slice, -1, -1);
                integer score_change = pie_slice_value(pie_slice_num);
                integer opid = pie_slice_option_index(pie_slice_num);
                if (score_change>0){
                	llTriggerSound("SND_WINNER", 1);
                    //avatar is correct
                    if (llListFindList(CORRECT_AVATARS, [avatar_name])==-1){ //dont add same name twice
                        sloodle_translation_request(SLOODLE_TRANSLATE_IM, [0], "correct_select_orb", [avatar_name], avatar_key, "hex_quizzer");
                        CORRECT_AVATARS+=avatar_key;//record which avatars are correct because only those who are correct can click an orb
                        llMessageLinked(LINK_SET, SLOODLE_CHANNEL_QUIZ_NOTIFY_SERVER_OF_RESPONSE,"multichoice|"+(string)question_id+"|"+(string)opid+"|"+(string)score_change, avatar_key);
                        llMessageLinked(LINK_SET, SLOODLE_CHANNEL_ANSWER_SCORE_FOR_AVATAR, (string)score_change+"|"+(string)llGetKey(), avatar_key);
                    }
                    
                }else{
                     llMessageLinked(LINK_SET, SLOODLE_CHANNEL_QUIZ_NOTIFY_SERVER_OF_RESPONSE,"multichoice|"+(string)question_id+"|"+(string)opid+"|"+(string)score_change, avatar_key);
                    sloodle_translation_request(SLOODLE_TRANSLATE_IM, [0], "incorrect_can_not_select_orb", [avatar_name], avatar_key, "hex_quizzer");
                    llPushObject(avatar_key,<0,0,100>, <0,0,-100>, TRUE);
                }
                
                string pie_slice_text =llList2String(pie_slice_hover_text,pie_slice_num);
                pie_slice_hover_text= llListReplaceList(pie_slice_hover_text, [pie_slice_text+"\n"+avatar_name], pie_slice_num, pie_slice_num);
                llMessageLinked(LINK_SET, SLOODLE_CHANNEL_ANIM, "orb show|0,1,2,3,4,5,6|10", NULL_KEY);
                integer j;
                string correct_avatars_str= "Avatars allowed to click:"+strReplace(llList2CSV(CORRECT_AVATARS),",","\n");
               
                for(j=1;j<=6;j++){
                    sloodle_translation_request("SLOODLE_TRANSLATE_HOVER_TEXT_LINKED_PRIM", [GREEN, 1.0,get_prim("orb")+(string)j], "option", [correct_avatars_str], "", "hex_quizzer");
                } 
                //check if this was the last question
                
                
            }
            //print names on pie slice hover text in GREEN if correct, in RED if incorrect
            string avatar_names;
            list grades=[];//retrieve the grade for each pie_slice
            vector color;
            for (pie_slice_num=1;pie_slice_num<=6;pie_slice_num++){
                     if (pie_slice_value(pie_slice_num)>0) {
                         color=GREEN;
                     }else{
                         color=RED;
                     }
                    avatar_names=llList2String(pie_slice_hover_text,pie_slice_num);
                    sloodle_translation_request("SLOODLE_TRANSLATE_HOVER_TEXT_LINKED_PRIM", [color, 1.0,get_prim("option"+(string)pie_slice_num)], "option", [avatar_names], "", "hex_quizzer");
                    integer grade = pie_slice_value(pie_slice_num);
                    grades+=grade;
            }
            //send the list of grades to the pie_slices so that they open or close.  If grade is 0 for that option, pie_slice will open
            llMessageLinked(LINK_SET, SLOODLE_CHANNEL_ANIM, "pie_slice|"+llList2CSV(grades), NULL_KEY);
            
            debug("sending grades to pie_slices: "+llList2CSV(grades));         
    
        };
    }
    object_rez(key platform) {
        //a new hex was rezzed, listen to the new hex platform
            llListen(SLOODLE_CHANNEL_QUIZ_MASTER_REQUEST, "", platform, "");
            rezzed_hexes+=platform;
            llGiveInventory(platform, HEXAGON_PLATFORM);
            debug("giving platform script");
            //since llRemoteLoadScriptPin makes a script sleep for 3 seconds, we need to offload the remote loading of the scripts to a seperate loader script
   /*         llMessageLinked(LINK_SET, SLOODLE_REMOTE_LOAD_SCRIPT, "0|"+(string)PIN+"|sloodle_translation_en.lslp|"+(string)TRUE+"|0", platform);
            llMessageLinked(LINK_SET, SLOODLE_REMOTE_LOAD_SCRIPT, "1|"+(string)PIN+"|sloodle_translation_hex_quizzer_en.lslp|"+(string)TRUE+"|0", platform);
            llMessageLinked(LINK_SET, SLOODLE_REMOTE_LOAD_SCRIPT, "2|"+(string)PIN+"|timer.lslp|"+(string)TRUE+"|0", platform);
            llMessageLinked(LINK_SET, SLOODLE_REMOTE_LOAD_SCRIPT, "3|"+(string)PIN+"|delayed_set_text.lslp|"+(string)TRUE+"|0", platform);
            llMessageLinked(LINK_SET, SLOODLE_REMOTE_LOAD_SCRIPT, "4|"+(string)PIN+"|feedback_request.lslp|"+(string)TRUE+"|0", platform);
            llMessageLinked(LINK_SET, SLOODLE_REMOTE_LOAD_SCRIPT, "5|"+(string)PIN+"|finish_quiz.lslp|"+(string)TRUE+"|0", platform);
            llMessageLinked(LINK_SET, SLOODLE_REMOTE_LOAD_SCRIPT, "6|"+(string)PIN+"|load_quiz.lslp|"+(string)TRUE+"|0", platform);
            llMessageLinked(LINK_SET, SLOODLE_REMOTE_LOAD_SCRIPT, "7|"+(string)PIN+"|notify_server_of_response.lslp|"+(string)TRUE+"|0", platform);
            llMessageLinked(LINK_SET, SLOODLE_REMOTE_LOAD_SCRIPT, "8|"+(string)PIN+"|sloodle_quiz_question_handler.lslp|"+(string)TRUE+"|0", platform);
            llMessageLinked(LINK_SET, SLOODLE_REMOTE_LOAD_SCRIPT, "9|"+(string)PIN+"|hex_multi_user_quiz.lslp|"+(string)TRUE+"|0", platform);
            llMessageLinked(LINK_SET, SLOODLE_REMOTE_LOAD_SCRIPT, "10|"+(string)PIN+"|rezzer_platform.lslp|"+(string)TRUE+"|0", platform);
            */
            llRemoteLoadScriptPin(platform, "sloodle_translation_hex_quizzer_en",PIN, TRUE, 0);
            llRemoteLoadScriptPin(platform, "rezzer_platform.lslp",PIN, TRUE, 0);
            
           
    }
    listen(integer channel, string name, key id, string message) {
        list data = llParseString2List(message, ["|"], []);
        string command = llList2String(data, 0);
        debug("************************** command is: "+command);
        if (command=="rezzed grandchild"){
               debug("a grandchild.. ");
               key grandchild=llList2Key(data,1);
            llListen(SLOODLE_CHANNEL_QUIZ_MASTER_REQUEST, "",grandchild, "");
            if (llListFindList(GRAND_CHILDREN,[grandchild])==-1){
                GRAND_CHILDREN+=grandchild;
            }
            debug("\n\n\n\nYay! a grandchild! listening to "+llList2CSV(GRAND_CHILDREN));

        }
       
        if (llListFindList(rezzed_hexes, [id])==-1&&llListFindList(GRAND_CHILDREN,[id])==-1){
            debug("---------------not my relative!!");
            llOwnerSay("---------------not my relative!!");
            //return;
        }
         debug("continuing");
        if (channel==SLOODLE_CHANNEL_QUIZ_MASTER_REQUEST){
            if (command=="GET CONFIG"){
                   debug("sending config data");
                   llRegionSayTo(id,SLOODLE_CHANNEL_QUIZ_MASTER_RESPONSE, "receive config"+HEX_CONFIG_SEPARATOR+CONFIG);
                
            }else
            if (command=="LOAD QUIZ"){
                key user_key = llList2Key(data,1);
                debug("received load quiz - current question is: "+(string)current_question+ " num questions is : "+(string)num_questions);
                if (current_question>num_questions){
                    if (doRepeat==TRUE){
                        current_question=0;
                    }else{
                        //TODO finish quiz for all avatars
                         sloodle_translation_request(SLOODLE_TRANSLATE_SAY, [0], "no_more_questions", [], NULL_KEY, "hex_quizzer");
                        return;
                    }
                }
                integer question_id = llList2Integer(question_ids,current_question);
                current_question++;
                debug("sending quiz data");
                debug("sending: "+"receive quiz data"+HEX_CONFIG_SEPARATOR+QUIZ_DATA+"|"+(string)question_id+"|"+(string)current_question);
                llRegionSayTo(id,SLOODLE_CHANNEL_QUIZ_MASTER_RESPONSE, "receive quiz data"+HEX_CONFIG_SEPARATOR+QUIZ_DATA+"|"+(string)question_id+"|"+(string)current_question);
            }
         }
            
    }
}
