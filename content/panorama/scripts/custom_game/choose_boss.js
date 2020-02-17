GameEvents.Subscribe( "choose_boss_start", StartChooseBoss )
GameEvents.Subscribe( "choose_boss_end", EndChooseBoss )

function BossButtonPressed( bossname ) {
	$( "#BossName" ).text = $.Localize( "choose_boss_" + bossname + "_name" )
	$( "#BossDescription" ).text = $.Localize( "choose_boss_" + bossname + "_osobenosti" )
	$.GetContextPanel().SetAttributeString( "bossname", bossname )
	$( "#BossInfo" ).style.visibility = "visible"
		
}

function ChooseBoss() {

	$( "#ChooseBossContainer" ).visible = false
	$( "#ChooseBossButton" ).enabled = false
	$( "#ChooseBossButton" ).visible = false
	
	GameEvents.SendCustomGameEventToServer( "choose_boss_chose", { bossname: $.GetContextPanel().GetAttributeString( "bossname", "necro" ) } )
}

function ChooseBossButton() {
	$( "#ChooseBossContainer" ).style.visibility = "visible"
	$( "#ChooseBossButton" ).enabled = false
	$( "#ChooseBossButton" ).visible = false
	
	$( "#BossName" ).text = $.Localize( "choose_boss_necro_name" )
	$( "#BossDescription" ).text = $.Localize( "choose_boss_necro_osobenosti" )
//	$.GetContextPanel().SetAttributeString( "bossname", "necr" )
	$( "#BossInfo" ).style.visibility = "visible"
	
}

function StartChooseBoss() {

	$( "#ChooseBossButton" ).style.visibility = "visible"
	$( "#ChooseBossButton" ).enabled = true
	$( "#ChooseBossButton" ).visible = true
}

function EndChooseBoss() {
	$( "#ChooseBossContainer" ).visible = false
	$( "#ChooseBossButton" ).visible = false
}


function CheckForHostPrivileges() {
	var player_info = Game.GetLocalPlayerInfo();
	if ( !player_info ) {
		return undefined;
	} else {
		return player_info.player_has_host_privileges;
	} 
}