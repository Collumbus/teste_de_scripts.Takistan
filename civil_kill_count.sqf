if (isServer) then {

    civKia = 0;

    // Declara uma variavel fora do escopo normal

    unitName = ""; 

    fnc_civkia_AEGIS = { 
        private ["_side","_kiaPos"]; 
        _kiaPos = getPos (_this select 0); 
        _side = side (_this select 1);

        // Pega o nome da unidade e seta a variavel
        // O handler retorna dois objetos no array
        // Voce usa o select pra pegar esses objetos. Ex: select 0 pega a unidade em que o handler foi colocado. select 1 pega a unidade que matou.
        // Ver: https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Killed

        unitName = name (_this select 1);

        if (_side == WEST || side player == sideEnemy) then { 
            civKia = civKia + 1; 
            publicvariable "civKia"; 
            _m = createMarker [format ["m_civKia_%1", civKia], _kiaPos]; 
            _m setMarkerShape "ICON"; _m setMarkerType "mil_dot"; _m setMarkerColor "ColorGreen"; _m setMarkerText format ["CKIA-%1",civKia]; 
            publicVariable "_m";             
        } 
    };{ 
    if ((side _x == Civilian) && (_x iskindof "Man")) then { 
      _x addEventhandler ["killed",fnc_civkia_AEGIS]; 
    }; 
    } foreach allUnits; 
} else { 
    fnc_civKiaMsg = {hint parseText format [" 
        <t color='#C1C3CB' align='left'>Central: Foi constatado que um civil foi morto em ação pelas equipes AEGIS!<br/><br/>O número total de mortos civis é: </t> 
        <t color='#FFFFFF' align='left' size='1.2'>%1 </t><br/><br/> 
        <t color='#C1C3CB' align='left' size='1'>Os civis assassinados estão marcados no mapa com um </t> 
        <t color='#65B418' align='left' shadow='1.2'>ponto verde</t> <br/><br/> 
        <t>Quem matou foi o %2</t>
        "
        // Adicionamos então o unitName ao format.
        , civKia, unitName]; 
    }; 
  "civKia" addPublicVariableEventHandler {call fnc_civKiaMsg}; 
}; 