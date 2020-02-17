"use strict" 
const _ = GameUI.CustomUIConfig()._;

function FormatGold(value) {
  // ark120202
	return (value > 9999999 
		? (value/1000000).toFixed(2) + 'M' 
		: value > 99999 
			? (value/1000).toFixed(1) + 'K' 
			: value)
		.toString()
		.replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
}

function FillPanel(_data){
	const parent = $('#PinnedRadiant')
	let __default = [ 
		{
			StrengthCandy:"???",
			AgilityCandy:"???",
			IntellectCandy:"???",
			MMR:"???",  
			Items:{},
			TotalDamageTaken:"???",
			TotalDamage:"???",
			IsWin:false,
		}
	]
	let data = CustomNetTables.GetTableValue('request', 'GameEnd') || (_data && _data.GameData) || __default
	const RadiantPlayerRows = $("#RadiantPlayerRows")
	RadiantPlayerRows.RemoveAndDeleteChildren()
	const context = $.GetContextPanel();
	parent.RemoveAndDeleteChildren() 
	let IsWin = false;
	_.each(Game.GetAllPlayerIDs(),(pID) =>{ 
		let info = Game.GetPlayerInfo(pID);
		let dataServer = data[pID] || __default[0] 
		let items = dataServer.Items
		IsWin = IsWin || (dataServer.IsWin == 1)
		let _parent = $.CreatePanel('Panel',parent,'Player_row' + pID);
		_parent.BLoadLayout('file://{resources}/layout/custom_game/layouts/game_end_player_row.xml', false,false)
		_parent.SetDialogVariable('hero_name',$.Localize(info.player_selected_hero))  
		_parent.FindChildTraverse('HeroImage').SetImage('file://{images}/heroes/' + info.player_selected_hero + '.png'); //.heroname = info.player_selected_hero 
		_parent.FindChildTraverse('heroLevel').text = Players.GetLevel(pID)
		_parent.FindChildTraverse('PlayerNameScoreboard').steamid = info.player_steamid
		let __parent = $.CreatePanel('Panel',RadiantPlayerRows,'Player_row_' + pID);
		__parent.BLoadLayout('file://{resources}/layout/custom_game/layouts/game_end_player_statistics.xml', false,false)
		__parent.FindChildTraverse('last_hits').text = Players.GetLastHits(pID)
		__parent.FindChildTraverse('deaths').text = Players.GetDeaths(pID)
		__parent.FindChildTraverse('net_worth').text = FormatGold(Players.GetTotalEarnedGold(pID))
		__parent.SetDialogVariable('str', dataServer.StrengthCandy)
		__parent.SetDialogVariable('agi', dataServer.AgilityCandy)
		__parent.SetDialogVariable('int', dataServer.IntellectCandy)
		__parent.SetDialogVariable('mmr', dataServer.MMR)
		__parent.SetDialogVariable('damage_taken', FormatGold(dataServer.TotalDamageTaken.toFixed(0)))
		__parent.SetDialogVariable('damage_deal', FormatGold(dataServer.TotalDamage.toFixed(0)))
 
		for (let index in items){
			let itemSlot = __parent.FindChildTraverse('ItemIcon' + index)
			if (itemSlot)
				itemSlot.itemname = items[index].sName
		}
	}) 
	context.AddClass('ScoreboardVisible')  
	context.SetHasClass('RadiantVictory', IsWin)
	context.SetDialogVariable('radiant_name', $.Localize('#DOTA_Scoreboard_GoodGuys'))
	$('#DetailsScoreboardContainer').AddClass('TabSelected')
	$('#LoadingContainer').AddClass('bHasServerInfo')
}

(function(){
	// $("#RadiantPlayerRows").RemoveAndDeleteChildren()
	// $('#PinnedRadiant').RemoveAndDeleteChildren()
	// const context = $.GetContextPanel();
	// context.RemoveClass('ScoreboardVisible')  
	// $('#DetailsScoreboardContainer').RemoveClass('TabSelected')
	let dataNet = CustomNetTables.GetTableValue('request', 'GameEnd')
	GameEvents.Subscribe('OnGameEnd',function(data){
		if (!dataNet)
			FillPanel(data)
	})
	if (dataNet){
		FillPanel()
	}
})()