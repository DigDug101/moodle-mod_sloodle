<?php
$sloodleconfig = new SloodleObjectConfig();
$sloodleconfig->primname   = 'sofa';
$sloodleconfig->object_code= 'sofa';
$sloodleconfig->modname    = 'furniture-1.0';
$sloodleconfig->group      = 'misc';
$sloodleconfig->collections= array('Avatar Classroom 2.0 Furniture A');
//parameter name, translation text, description, default value, length
$sloodleconfig->field_sets = array(
'generalconfiguration'=> array(
 'color' => new SloodleConfigurationOptionText( 'color', 'misc:sofa', '', '<0,1,0>', 40 ) 
	 ));
