var TimerLabel
function FixHeroIcons(){
    var playerSlots = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("topbar").FindChildrenWithClassTraverse("TopBarPlayerSlot")

    for ( k in playerSlots ){
        var img = playerSlots[k].FindChildTraverse("HeroImage")   
        if (img.heroname){
            if ( img.Children().length == 0 ) {
            	$.Msg( img.heroname )
                var new_img = $.CreatePanel( "Image", img, "ImageOverride" ) 
            } else {
            	img.FindChild( "ImageOverride" ).SetImage( "file://{images}/custom_game/heroes/"+img.heroname+".png" )
            }
        }
    }
    var timer = CustomNetTables.GetTableValue('BossTimer', 'Timer')
    var seconds  = timer 
        ? (timer.time == -1 && 0 || timer.time - Game.GetDOTATime(false, false))
        : 0
    TimerLabel.text = secondsToMS(seconds)
    $.Schedule( 0.1, FixHeroIcons )
}

function secondsToMS(seconds, bTwoChars) {
    seconds = seconds || Game.GetDOTATime(false, false)
    var sec_num = parseInt(seconds, 10);
    var minutes = Math.floor(sec_num / 60);
    var seconds = Math.floor(sec_num - minutes * 60);

    if (bTwoChars && minutes < 10)
        minutes = '0' + minutes;
    if (seconds < 10)
        seconds = '0' + seconds;
    return minutes + ':' + seconds;
}

function GetDotaHud() {
    var rootUI = $.GetContextPanel();
    while (rootUI.id != "Hud" && rootUI.GetParent() != null) {
        rootUI = rootUI.GetParent();
    }
    return rootUI;
}

function UpdateTopBar(){
    var base = GetDotaHud().FindChildTraverse('TopBarDireTeamContainer')
    var panel = base.FindChildTraverse('TopBarTime')
    if (panel)
        panel.DeleteAsync(0) 
    panel = $.CreatePanel('Panel',base,'TopBarTime')
    panel.BLoadLayout("file://{resources}/layout/custom_game/topBarXML.xml", false, false)
    TimerLabel = panel.FindChildTraverse('TimerLabel')
    let table = CustomNetTables.GetTableValue('top_bar', 'Difficuilt');
    let data = [
        "imba_gamemode_settings_lock_options",
        "imba_gamemode_settings_lock_options1",
        "imba_gamemode_settings_lock_options2",
        "imba_gamemode_settings_lock_options3", 
    ]
    let data_img = [
        'panorama/images/rank_tier_icons/rank1_psd.vtex',
        'panorama/images/rank_tier_icons/rank5_psd.vtex',
        'panorama/images/rank_tier_icons/rank7_psd.vtex',
        'panorama/images/rank_tier_icons/rank8_psd.vtex'
    ]
    // url("s2r://panorama/images/rank_tier_icons/rank2_psd.vtex")
    let diff = table && table.DIFFICULTY || 0
    panel.FindChildTraverse('Difficult').text = $.Localize(data[diff])
    $.Msg(`s2r://{images}/${data_img[diff]}`)
    panel.FindChildTraverse('Difficult_img').SetImage(`s2r://${data_img[diff]}`); 
}
UpdateTopBar()
FixHeroIcons() 