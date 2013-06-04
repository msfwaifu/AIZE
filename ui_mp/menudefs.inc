#define CHOICE_RECTCS(i) -245 (-150+(i*35)) 210 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
	
#define PRICE(itemIndex,priceArg) \
		itemDef  \
		{ \
		rect			0 5 500 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER \
		textalignx		0 \
		textaligny 		0 \
		textalign		ITEM_ALIGN_MIDDLE \
		textfont 		9 \
		textscale		0.25 \
		forecolor		1 0.8 0.3 1 \
		exp				text ("PRICE : $" + priceArg)	\
		visible			when(localVarInt( ui_highlight1 ) == itemIndex) \
		decoration 		\
		}
		
#define MENU_CSBUTTON(itemIndex,nameArg,weapon,priceArg) \
	MENU_FORE(itemIndex, nameArg, exec "openscriptmenu -1 "weapon, exec "set loadout_tobuy "weapon,(dvarString(money) >= priceArg && !dvarInt(weapon+"_owned"))) \
	MENU_DBUTTON_F(itemIndex, nameArg, exec "set loadout_tobuy "weapon,(dvarString(money) < priceArg || dvarInt(weapon+"_owned"))) \
	PRICE(itemIndex,priceArg)
	
#define MENU_CSBUTTON_X(itemIndex,nameArg,weapon,priceArg,customfocus) \
	MENU_FORE(itemIndex, nameArg, exec "openscriptmenu -1 "weapon, exec "set loadout_tobuy "customfocus,(dvarString(money) >= priceArg && !dvarInt(weapon+"_owned"))) \
	MENU_DBUTTON_F(itemIndex, nameArg, exec "set loadout_tobuy "customfocus,(dvarString(money) < priceArg || dvarInt(weapon+"_owned"))) \
	PRICE(itemIndex,priceArg)
	
		
#define MENU_FOCUS(itemIndex,visArg) \
		itemDef \
		{ \
			visible 	when(visArg && localVarInt( ui_highlight0 ) == itemIndex) \
			type 		ITEM_TYPE_BUTTON \
			rect 		CHOICE_RECTCS(itemIndex) \
			style 		WINDOW_STYLE_FILLED \
			background 	white \
			backColor 	1 0.2 0.1 0.5 \ 
			border		1 \
			bordercolor 1 0.8 0.3 0.8 \
			borderSize 	1 \
		}
		
#define MENU_TEXT(itemIndex,onFocusArg,textArg,visArg,actionArg) \
		itemDef \
		{ \
			rect 		CHOICE_RECTCS(itemIndex) \
			type 		ITEM_TYPE_BUTTON \
			style 		WINDOW_STYLE_EMPTY \
			textstyle 	ITEM_TEXTSTYLE_SHADOWED \
			foreColor 	1 0.8 0.3 1 \
			textAlign 	4 \
			textAlignX 	10 \
			textAlignY 	3 \
			textScale 	0.3 \
			textfont	9 \
			exp	text 	(textArg) \
			visible 	when(visArg) \
			onFocus \
			{ \
				onFocusArg; \
				setLocalVarInt ui_highlight0 itemIndex; \
				setLocalVarInt ui_highlight1 itemIndex; \
			} \
			leaveFocus \
			{ \
				setLocalVarInt ui_highlight0 0; \
			} \
			action \
			{ \
				play mouse_click; \
				actionArg \
			} \
		}
			
#define MENU_FORE(itemIndex,textArg, actionArg,onFocusArg,visArg) \
		itemDef \
		{ \
			visible 	 when(visArg) \
			type 		 ITEM_TYPE_BUTTON \
			rect 		 CHOICE_RECTCS(itemIndex) \
			style 		 WINDOW_STYLE_FILLED \
			border		 1 \
			bordercolor  1 0.8 0.3 0.8 \
			borderSize 	 1 \
			backColor    0 0 0 0.1 \
		} \
		MENU_FOCUS(itemIndex,visArg) \
		MENU_TEXT(itemIndex,onFocusArg,textArg,visArg,actionArg) \
		execKey itemIndex { actionArg }
		
#define MENU_DBUTTON(itemIndex,textArg,onFocusArg,visArg) \
		itemDef \
		{ \
			rect 			CHOICE_RECTCS(itemIndex) \
			type 			ITEM_TYPE_BUTTON \
			style 			WINDOW_STYLE_EMPTY \
			textstyle 		ITEM_TEXTSTYLE_SHADOWED \
			textfont		9 \
			foreColor 		0.5 0.5 0.5 1 \
			textAlign 		4 \
			textAlignX 		10 \
			textAlignY 		3 \
			textScale 		0.3 \
			exp	text 		(textArg) \
			visible 		when(visArg) \
			onFocus \
			{ \
				onFocusArg; \
				setLocalVarInt ui_highlight0 itemIndex; \
				setLocalVarInt ui_highlight1 itemIndex; \
			} \
			leaveFocus \
			{ \
				setLocalVarInt ui_highlight0 0; \
			} \
		} \
		
#define MENU_DBUTTON_F(itemIndex,textArg,onFocusArg,visArg) \
		itemDef \
		{ \
			visible 		when(visArg) \
			type 			ITEM_TYPE_BUTTON \
			rect 			CHOICE_RECTCS(itemIndex) \
			style			WINDOW_STYLE_FILLED \
			border			1 \
			bordercolor		1 0.8 0.3 0.8 \
			bordersize 		1 \
			backColor 		0 0 0 0.1 \
		} \
		MENU_FOCUS(itemIndex,visArg) \
		MENU_DBUTTON(itemIndex,textArg,onFocusArg,visArg)
		
#define CHOICE_MENU_RECT(i) -30 ( 200 + ( i * 30 ) ) 110 20 HORIZONTAL_ALIGN_LEFT 1

#define MENU_CHOICE_BUTTON_VIS( itemIndex, textArg, actionArg, visArg) \
		itemDef \
		{ \
			rect CHOICE_MENU_RECT(itemIndex) \
			foreColor 1 1 1 1 \
			style 1 \
			group mw2_button \
			type 1 \
			textAlign ITEM_ALIGN_LEFT \
			textAlignX 0 \
			textAlignY 20 \
 			textScale 0.375 \
			textFont 3 \
			text textArg \
			onFocus \
			{ \
				play mouse_over; \
			} \
			action \
			{ \
				play mouse_click; \
				actionArg \
			} \
			visible visArg \
		}		
		
#define CHOICE_RECTCS_POS(i) 0 (45+(i*35)) 210 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER

#define MENU_FOCUS_POS(itemIndex,visArg) \
        itemDef \
        { \
            visible     when(visArg && localVarInt( ui_highlight2 ) == itemIndex) \
            type         ITEM_TYPE_BUTTON \
            rect         CHOICE_RECTCS_POS(itemIndex) \
            style         WINDOW_STYLE_FILLED \
            background     white \
            backColor     1 0.2 0.1 0.5 \
            border        1 \
            bordercolor 1 0.8 0.3 0.8 \
            borderSize     1 \
        }

#define MENU_TEXT_POS(itemIndex,onFocusArg,textArg,visArg,actionArg) \
        itemDef \
        { \
            rect         CHOICE_RECTCS_POS(itemIndex) \
            type         ITEM_TYPE_BUTTON \
            style         WINDOW_STYLE_EMPTY \
            textstyle     ITEM_TEXTSTYLE_SHADOWED \
            foreColor     1 0.8 0.3 1 \
            textAlign     4 \
            textAlignX     10 \
            textAlignY     3 \
            textScale     0.3 \
            textfont    9 \
            exp    text     (textArg) \
            visible     when(visArg) \
            onFocus \
            { \
                onFocusArg; \
                setLocalVarInt ui_highlight2 itemIndex; \
            } \
            leaveFocus \
            { \
                setLocalVarInt ui_highlight2 0; \
            } \
            action \
            { \
                play mouse_click; \
                actionArg \
            } \
        }

#define MENU_FORE_POS(itemIndex,textArg, actionArg,onFocusArg,visArg) \
        itemDef \
        { \
            visible      when(visArg) \
            type          ITEM_TYPE_BUTTON \
            rect          CHOICE_RECTCS_POS(itemIndex) \
            style          WINDOW_STYLE_FILLED \
            border         1 \
            bordercolor  1 0.8 0.3 0.8 \
            borderSize      1 \
            backColor    0 0 0 0.1 \
        } \
        MENU_FOCUS_POS(itemIndex,visArg) \
        MENU_TEXT_POS(itemIndex,onFocusArg,textArg,visArg,actionArg)
