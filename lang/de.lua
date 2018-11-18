
-- Check Behavior of GetString
local lang = {
	
	-- parameters are itemDescription, qualityRangeText, isSetText, actionText
	-- e.g. "put in trash any stolen worthless light armor with quality Trash to Normal"
	IM_RULETXTFORMAT			= "<<4>>: jeder <<1>><<z:2>><<z:3>>",
	IM_RULETXT_ISSET			= "(Teil eines Sets)",
	IM_RULETXT_STOLEN			= "gestohlene(s)",
	IM_RULETXT_WORTHLESS		= "wertlos(es)",
	IM_RULETXT_JUNKED			= "weggeworfene(s)",
	IM_RULETXT_CRAFTED			= "hergestellte(s)",
	IM_RULETXT_QUALITY1			= "mit Qualität <<1>>",
	IM_RULETXT_QUALITY2			= "mit Qualität von <<1>> bis <<2>>",
	IM_RULETXT_EXECOUNT 		= "(max. <<1>>-mal)",
  IM_RULETXT_TXT          = "passend auf '<<1>>'",

	IM_ACTIONTXT0				= "Behalten",
	IM_ACTIONTXT1				= "Zum Müll stecken",
	IM_ACTIONTXT2				= "Vernichten",
	IM_ACTIONTXT3				= "Verkaufen",
	IM_ACTIONTXT4				= "Waschen",
	IM_ACTIONTXT5				= "Zerlegen",
	IM_ACTIONTXT6				= "Sperren",
	IM_ACTIONTXT7				= "Entsperren",
	IM_ACTIONTXT10				= "Einlagern",
	IM_ACTIONTXT11				= "Einlagern in Gildenbank",
	IM_ACTIONTXT20				= "Auslagern",
	IM_ACTIONTXT21				= "Auslagern aus Gildenbank",
	
	IM_TAKENACTION0				= "Würde <<z:1>>: |t16:16:<<2>>|t <<3>> wegen Regel <<4>>: <<5>>.",
	IM_TAKENACTION1				= "<<1>>: |t16:16:<<2>>|t <<3>>",
	IM_TAKENACTION2				= "Würde |cff4444NICHT|r <<z:1>>: |t16:16:<<2>>|t <<3>> wegen Regel <<4>>: <<5>>, aber es ist durch FCOIS gesperrt",

	IM_FILTER_RULE_ANY			= "Alle",
	IM_FILTER_ANY0				= "Gegenstand",
	IM_FILTERSPEC_ANY0			= "<<1>>",
	IM_FILTER_WEAPON0			= "Waffe",
	IM_FILTERSPEC_1H0			= "Einhandwaffe",
	IM_FILTERSPEC_2H0			= "Zweihandwaffe",
	IM_FILTERSPEC_BOW0			= "Bogen",
	IM_FILTERSPEC_STAFF_DEST0 	= "Zerstörungsstab",
	IM_FILTERSPEC_STAFF_HEAL0 	= "Heilstab",
	IM_FILTER_APPAREL0			= "Tragbares",
	IM_FILTERSPEC_ANY_BODY0		= "Schutzbekleidung",
	IM_FILTERSPEC_HEAVY0		= "Schwere Rüstung",
	IM_FILTERSPEC_MEDIUM0		= "Mittlere Rüstung",
	IM_FILTERSPEC_LIGHT0		= "Leichte Rüstung",
	IM_FILTERSPEC_SHIELD0		= "Schild",
	IM_FILTERSPEC_JEWELRY0		= "Juwelen",
	IM_FILTERSPEC_VANITY0		= "Kostüme",
	IM_FILTER_CONSUMABLE0		= "Verbrauchsgüter",
	IM_FILTERSPEC_CROWN_ITEM0 	= "Kronengegenstand",
	IM_FILTERSPEC_FOOD0			= "Essen",
	IM_FILTERSPEC_DRINK0		= "Trinken",
	IM_FILTERSPEC_RECIPE0		= "Rezept",
	IM_FILTERSPEC_POTION0		= "Zaubertrank",
	IM_FILTERSPEC_POISON0		= "Gift",
	IM_FILTERSPEC_MOTIF0		= "Stilbuch",
	IM_FILTERSPEC_MASTER_WRIT0 	= "Meisterschieb",
	IM_FILTERSPEC_CONTAINER0	= "Behälter",
	IM_FILTERSPEC_REPAIR0		= "Reparatursatz",
	IM_FILTERSPEC_FISH0			= "Fisch",
	IM_FILTERSPEC_TROPHY0		= "Trophäe",
	IM_FILTER_MATERIAL0			= "Material",
	IM_FILTERSPEC_BLACKSMITHING0	= "Schmiedematerial",
	IM_FILTERSPEC_CLOTHIER0		= "Schneidermaterial",
	IM_FILTERSPEC_WOODWORKING0 	= "Holzhandwerkermasterial",
	IM_FILTERSPEC_ALCHEMY0		= "Alchimiematerial",
	IM_FILTERSPEC_ENCHANTING0 	= "Verzauberungsmaterial",
	IM_FILTERSPEC_PROVISIONING0 = "Kochzutat",
	IM_FILTERSPEC_STYLE_MATERIAL0 = "Stilmaterial",
	IM_FILTERSPEC_ARMOR_TRAIT0 	= "Rüstungsaufwertung",
	IM_FILTERSPEC_WEAPON_TRAIT0 = "Waffenaufwertung",
	IM_FILTER_FURNISHING0		= "Möbel",
	IM_FILTER_MISC0				= "Verschiedenes",
	IM_FILTERSPEC_GLYPH0		= "Glyphe",
	IM_FILTERSPEC_SOUL_GEM0 	= "Seelenstein",
	IM_FILTERSPEC_SIEGE0		= "Belagerungsausrüstung",
	IM_FILTERSPEC_BAIT0			= "Köder",
	IM_FILTERSPEC_TOOL0			= "Werkzeug",
	IM_FILTERSPEC_TRASH0		= "Müll",
	IM_FILTERSPEC_TREASURE0		= "Schatz",
	
	IM_META_TRAIT_TYPE_FORMAT0	= "<<1>> mit jeder Eigenschaft, die <<2>> ist",
	IM_META_TRAIT_TYPE_FORMAT1	= "<<1>> welches <<2>> ist",
	IM_META_TRAIT_TYPE_FORMAT2	= "<<1>> ohne eine Eigenschaft",
	IM_META_TRAIT_TYPE0			= "(irrelevant)",
	IM_META_TRAIT_TYPE1			= "jede Eigenschaft",
	IM_META_TRAIT_TYPE2			= "unbekannt für andere",
	IM_META_TRAIT_TYPE3			= "unbekannt",
	IM_META_TRAIT_TYPE4			= "keine Eigenschaft",
	
	IM_RE_CURRENTRULES			= "Derzeitige Regeln",
	IM_RE_DELETERULE			= "Regel löschen",
	IM_RE_MOVERULEUP			= "Regel nach oben",
	IM_RE_ADDRULEBEFORE			= "Neue Regel vor dieser",
	IM_RE_MOVERULEDN			= "Regel nach unten",
	IM_RE_ADDRULEAFTER			= "Neue Regel nach dieser",
	IM_RE_REPLACERULE			= "Regel ersetzen",
	IM_RE_DESC					= "Verändern Sie diese Felder um die Regel zu definieren, die Sie hinzufügen wollen.",
	IM_RE_ACTION				= "Aktion",
	IM_RE_GENTYPE				= "Typ",
	IM_RE_SPECTYPE				= "Spezieller Typ",
	IM_RE_TRAIT					= "Eigenschaft",
	IM_RE_PARTOFSET				= "Teil eines Sets",
	IM_RE_MINQUAL				= "Minimale Qualität",
	IM_RE_MAXQUAL				= "Maximale Qualität",
	IM_RE_STOLEN				= "Gestohlen",
	IM_RE_WORTHLESS				= "Wertlos",
	IM_RE_CRAFTED				= "Hergestellt",
	IM_RE_EMPTY					= "(leer)",
	IM_RE_INJUNK 				= "Im Müll",
	IM_RE_GUILDBANK				= "Gildenbank",
	IM_RE_GUILDBANK_TT			= "Die zu benutzende Gildenbank, wenn die Aktion eine erfordert",

	IM_PE_PROFILES				= "Profile",
	IM_PE_LOADPROFILE			= "Profil laden",
	IM_PE_DELETEPROFILE			= "Profil löschen",
	IM_PE_EDITPRNAME			= "Profilname",
	IM_PE_SAVEPROFILE			= "Profil speichern",
	
	IM_BANK_LIMITED				= "Transaktion unvollständig - ZOS Anti-Spam-Filterung",
	IM_BANK_DEADLOCK			= "Transaktion unvollständig - beide Lager voll",
	IM_BANK_PARTIAL				= "Transaktion unvollständig - eines der Lager voll",
	IM_BANK_OK					= "Transaktion abgeschlossen",

	IM_UI_LISTRULES_HEAD		= "Liste der Regeln",
	IM_SET_MIN_GOLD				= "Minimum Gold",
	IM_SET_MIN_GOLD_TOOLTIP		= "Wieviele Münzen mindestens beim Charakter behalten werden",
	IM_SET_MAX_GOLD				= "Maximum Gold",
	IM_SET_MAX_GOLD_TOOLTIP		= "Wieviele Münzen höchstens beim Charakter behalten werden",
	IM_SET_MIN_TV				= "Minimum Tel Var stones",
	IM_SET_MIN_TV_TOOLTIP		= "Wieviele Steine mindestens beim Charakter behalten werden",
	IM_SET_MAX_TV				= "Maximum Tel Var stones",
	IM_SET_MAX_TV_TOOLTIP		= "Wieviele Steine höchstens beim Charakter behalten werden",
	IM_SET_MIN_AP				= "Minimum Alliance Points",
	IM_SET_MIN_AP_TOOLTIP		= "Wieviele Allianzpunkte mindestens beim Charakter behalten werden",
	IM_SET_MAX_AP				= "Maximum Alliance Points",
	IM_SET_MAX_AP_TOOLTIP		= "Wieviele Allianzpunkte höchstens beim Charakter behalten werden",
	IM_SET_MIN_VW				= "Minimum Writ Vouchers",
	IM_SET_MIN_VW_TOOLTIP		= "Wieviele Schriebscheine mindestens beim Charakter behalten werden",
	IM_SET_MAX_VW				= "Maximum Writ Vouchers",
	IM_SET_MAX_VW_TOOLTIP		= "Wieviele Schriebscheine höchstens beim Charakter behalten werden",
	
	IM_SET_BANK					= "Bank-Verzögerung",
	IM_SET_BANK_TOOLTIP			= "Zeit in Millisekunden zwischen einzelnen Bankbewegungen",
	IM_SET_DEST					= "Zerstörungsschwelle",
	IM_SET_DEST_TOOLTIP			= "Zerstöre die durch Regeln angegebenen Gegenstände, wenn weniger Slots frei sind als hier angegeben",
	IM_SET_LIST					= "Regeln auflisten",
	IM_SET_LIST_TOOLTIP			= "Listet alle Regeln im Chatfenster auf",
	IM_SET_UNJUNK				= "Müll-Marker löschen",
	IM_SET_UNJUNK_TOOLTIP		= "Löscht alle Müll-Markierungen auf den Gegenständen im Inventar",
	IM_SET_DRYRUN				= "Probelauf",
	IM_SET_DRYRUN_TOOLTIP		= "Listet die Aktionen, die auf die Gegenstände im Inventar ausgeführt würden",
	IM_SET_RUN					= "Inventar bearbeiten",
	IM_SET_RUN_TOOLTIP			= "Führt die Wegwerf/Zerstörungsaktionen über die Gegenstände im Inventar aus",

	IM_SET_AUTOSELL				= "Gegenstandsverkauf aktiviert",
	IM_SET_AUTOSELL_TOOLTIP		= "Verkauft die Gegenstände anhand der gesetzten Regeln. Hiermit kann man es zeitweilig abschalten, wenn es nötig wird, ohne die Regeln zu ändern.",
	IM_SET_START_BM 			= "Verzögerung vor Bankbewegung",
	IM_SET_START_BM_TT 			= "Setzt die Verzögerung, bevor mit Bankbewegungen angefangen wird. Es ist ratsam, bei hochvolumigen Addons wie Inventory Grid View einen höheren Wert anzusetzen.",
	IM_SET_INV 					= "Verzögerung zw. Inv.-Änderung",
	IM_SET_INV_TT 				= "Setzt die Verzögerung zwischen Änderungen im Inventar wie Sperren/Entsperren usw.",
	IM_SET_EXECOUNT 			= "Maximale Anzahl Ausführungen",
	IM_SET_EXECOUNT_TT 			= "Wie oft diese Regel maximal in einem Lauf ausgeführt werden darf. 0 bedeutet 'unbegrenzt'",
	IM_SET_RULELIST       = "Regelliste",
  IM_SET_RULELIST_TT    = "Gibt die Gelegenheit an, bei der die nachfolgende Liste angewendet wird",
  IM_SET_NEGATE         = "Negieren",
  IM_SET_NEGATE_TT      = "Wenn gesetzt, wird diese Aktion NICHT auf die Gegenstände angewendet, die passen",
  IM_SET_XREF           = "Kreuzreferenz",
  IM_SET_XREF_TT        = "Wenn gesetzt, verweist es auf eine andere Regelliste, die zu Rate gezogen wird",
  IM_SET_TXTMATCH       = "Filtertext",
  IM_SET_TXTMATCH_TT    = "Wenn nicht leer, bezeichnet es den Namen oder einen Namensteil von dem passenden Objekt. Reguläre Ausdrücke sind zulässig.",
  IM_SET_BANK_LIMITS_GOLD = "Gold-Limits auf Bank anwenden",
  IM_SET_BANK_LIMITS_TV   = "Tel-Var-Stein-Linits auf Bank anwenden",
  IM_SET_BANK_LIMITS_AP = "Alliance-Points auf Bank anwenden",
  IM_SET_BANK_LIMITS_WV   = "Writ-Vouchers auf Bank anwenden",
  IM_SET_BANK_LIMITS_TT   = "Wenn gesetzt, werden die unten angegebenen Werte auf die Bank anstatt auf den Charakter angewendet",
  IM_SET_PROGRESS         = "Fortschrittsbericht",
  IM_SET_PROGRESS_TT      = "Wenn Aktionen ausgeführt werden, wird im Chatfenster ein Fortschrittsbericht angezeigt.",

	IM_PM_PROFILENAME_TOOLTIP	= "Namen vom Profil hier eingeben",
	IM_RM_PRESETRULES			= "--- Voreingestellte Profile ---",
	IM_RM_CUSTOMRULES			= "--- Eigene Profile ---",
	IM_LIST_NUM_RULES			= "Gefundene Regeln: ",
	IM_LIST_RULE				= "Regel ",
	IM_UI_PM					= "Profilmanagement",
	IM_UI_PM_TOOLTIP			= "Auswählen, Hinzufügen und Löschen von Profilen",
	IM_UI_RM					= "Regelmanagement",
	IM_UI_RM_TOOLTIP			= "Auswählen, Hinzufügen und Löschen von Regeln",
	IM_UI_SETTINGS				= "Einstellungen",
	IM_UI_SETTINGS_TOOLTIP		= "Generelles Verhalten anpassen",
	IM_CUR_SOLDJUNK				= "Gegenstände verkauft, Erlös <<1>> Münzen.",
	IM_CUR_DEPOSIT				= "Zahle <<1>> <<2>> ein.",
	IM_CUR_WITHDRAW				= "Hebe <<1>> <<2>> ab.",

	IM_FCOIS_CHOICE			= "FCO ItemSaver Markierung",
	IM_FCOIS_UNMARKED			= "unmarkiert(es)",
	IM_FCOIS_WITHANYMARK		= "mit einer Markierung",
	IM_FCOIS_MARKEDASX			= "markiert als <<z:1>>",
	IM_FCOIS_NOCAREMARK		= "Nicht relevant",
	IM_FCOIS_NOMARK			= "Keine Markierung",
	IM_FCOIS_ANYMARK			= "Irgendeine Markierung",

	IM_INIT_DETECTED_CS_OLD	= "IM: Altes CraftStore 3.00+ AddOn erkannt. Es ist überholt, bitte aktualisieren Sie auf 'CraftStore Fixed And Improved'",
	IM_INIT_DETECTED_CS_NEW	= "IM: CraftStore Fixed And Improved AddOn erkannt",
	IM_INIT_UPDATE_V2_NOTE 	= "Aktualisiere Charakterdaten nach Version 2: Regel 'Verkaufe alle Gegenstände im Müll' hinzugefügt, um altes Verhalten beizubehalten.",
  IM_INIT_UPDATE_V3_NOTE  = "Aktualisiere Charakterdaten nach Version 3: Regeln neu organisiert",

	IM_FCO_STATIC_TXT1			= "zur Sperrung",
	IM_FCO_STATIC_TXT2			= "Ausrüstungssatz 1",
	IM_FCO_STATIC_TXT3			= "für Forschung",
	IM_FCO_STATIC_TXT4			= "Ausrüstungssatz 2",
	IM_FCO_STATIC_TXT5			= "zum Verkauf",
	IM_FCO_STATIC_TXT6			= "Ausrüstungssatz 3",
	IM_FCO_STATIC_TXT7			= "Ausrüstungssatz 4",
	IM_FCO_STATIC_TXT8			= "Ausrüstungssatz 5",
	IM_FCO_STATIC_TXT9			= "zur Zerlegung",
	IM_FCO_STATIC_TXT10			= "zur Verbesserung",
	IM_FCO_STATIC_TXT11			= "zum Verkauf im Gildenladen",
	IM_FCO_STATIC_TXT12			= "aufwändig",

  IM_R2_HEADING0          = "(Keine Kreuzreferenz)",
  IM_R2_HEADING1          = "Beim Aufheben eines Gegenstands, in den Müll, wenn ...",
  IM_R2_HEADING2          = "Beim vollen Inventar, vernichte ...",
  IM_R2_HEADING3          = "Verkaufe beim Geschäft oder Hehler ...",
  IM_R2_HEADING4          = "Wasche beim Hehler ...",
  IM_R2_HEADING5          = "Am Arbeitstisch, zerlege ...",
  IM_R2_HEADING10         = "Lege in die eigene Bank ...",
  IM_R2_HEADING20         = "Hole aus der eigenen Bank ...",
  IM_R2_HEADING11         = "Lege die in der Regel angegebenen Gildenbank ...",
  IM_R2_HEADING21         = "Hole aus die in der Regel angegebenen Gildenbank ...",
  IM_R2_COUNT_TAG         = " (Regeln: <<1>>)",

	IM_R2_FORMAT0     			= "Kein <<1>><<z:2>><<z:3>> <<4>>",         -- Rule V2 text, negative
	IM_R2_FORMAT1     			= "Jeder <<1>><<z:2>><<z:3>> <<4>>",        -- Rule V2 text, positive
  IM_R2_FORMAT2           = "Nichts von der Liste '<<z:1>>' <<2>>",   -- Rule V2 text, cross reference, negative
  IM_R2_FORMAT3           = "Alles von der Liste '<<z:1>>' <<2>>"     -- Rule V2 text, cross reference, positive

}

for stringId, stringValue in pairs(lang) do
   ZO_CreateStringId(stringId, stringValue)
   SafeAddVersion(stringId, 1)
end
