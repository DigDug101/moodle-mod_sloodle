<?php
    // This script is part of the Sloodle project
    // Created for Avatar Classroom, with the intention of eventually being ported back to regular Sloodle.
    // Some assumptions that are true for Avatar Classroom won't be true for arbitrary Moodle sites.
    // I'll try to comment these REGULAR SLOODLE TODO.

    /**
    * @package sloodle
    * @copyright Copyright (c) 2011 various contributors (see below)
    * @license http://www.gnu.org/licenses/gpl-3.0.html GNU GPL v3
    *
    * @contributor Edmund Edgar
    *
    */

    /** Grab the Sloodle/Moodle configuration. */
    require_once('../../../sl_config.php');
    /** Include the Sloodle PHP API. */
    /** Sloodle core library functionality */
    require_once(SLOODLE_DIRROOT.'/lib.php');
    /** General Sloodle functions. */
    require_once(SLOODLE_LIBROOT.'/general.php');
    /** Sloodle course data. */
    require_once(SLOODLE_LIBROOT.'/course.php');

    require_once(SLOODLE_LIBROOT.'/object_configs.php');
    require_once(SLOODLE_LIBROOT.'/active_object.php');

    require_once '../../../lib/json/json_encoding.inc.php';
//ini_set('display_errors', 1);
//error_reporting(E_ALL);

	// Register the set using URL parameters

	$content = array();

	$ao = new SloodleActiveObject();
	$object_uuid = required_param('sloodleobjuuid');
	if (!$ao->loadByUUID($object_uuid)) {
		print "not found";
		exit;
	}

	$controllerid = intval($ao->controllerid);
	$currencyid = intval($ao->config_value('sloodlecurrencyid'));
	$roundid = intval($ao->config_value('sloodleroundid'));

	// TODO: Check if they're a teacher, if so give them the teacher view.
	$is_admin = false;
	$is_logged_in = isset($USER) && ($USER->id > 0);
$is_logged_in = false;

	$userid = required_param('userid');
	
	if (!$userid = intval($userid)) {
		continue;
	}

	$deleted = delete_records( 'sloodle_award_points', 'roundid', $roundid, 'userid', $userid );

	// TODO: Add round filter etc
	$sql = "select max(u.userid) as userid, sum(p.amount) as balance, u.avname as avname from {$CFG->prefix}sloodle_award_points p left outer join {$CFG->prefix}sloodle_users u on p.userid=u.userid group by u.userid order by balance desc, avname asc;";
	$updated_score_recs = get_records_sql( $sql );
	$updated_scores = array();
	foreach($updated_score_recs as $score) {
		$updated_scores[ $score->userid ] = $score;
	}
	
/*
$updated_scores[ 2 ]->balance = 1000;
if (time() % 2 == 0) {
$updated_scores[ 7 ]->balance = 2000;
} else {
$updated_scores[ 7 ]->balance = 500;
}
*/


	$result = 'deleted';

	$content = array(
		'result' => $result,
		'error' => $error,
		'updated_scores' => $updated_scores
	);

	print json_encode($content);
	exit;

function error_output($error) {
        $content = array(
                'result' => 'failed',
                'error' => $error,
        );
        print json_encode($content);
        exit;
}
?>