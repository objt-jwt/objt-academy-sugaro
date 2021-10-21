/*
 Objective keyboards
 */

$.keyboard.layouts['objt-azerty'] = {
	'default' : [
		"\u00b2 & \u00e9 \" ' ( - \u00e8 _ \u00e7 \u00e0 ) = {b}",
		"{t} a z e r t y u i o p ^ $",
		"q s d f g h j k l m  \u00f9 * {e}",
		"{s} < w x c v b n , ; : ! {s}",
		"{a} {alt} {space} {alt} {c}"
	],
	'shift' : [
		"\u00b3 1 2 3 4 5 6 7 8 9 0 \u00b0 + {b}",
		"{t} A Z E R T Y U I O P \u00a8 \u00a3",
		"Q S D F G H J K L M % \u00b5 {e}",
		"{s} > W X C V B N ? . / \u00a7 {s}",
		"{a} {alt} {space} {alt} {c}"
	],
	'alt' : [
		"\u00b2 & ~ # { [ | ` \\ ^ @ ] } {b}",
		"{t} a z \u20ac r t y u i o p ^ \u00a4",
		"q s d f g h j k l m  \u00f9 * {e}",
		"{s} < w x c v b n , ; : ! {s}",
		"{a} {alt} {space} {alt} {c}"
	],
	'alt-shift' : [
		"\u00b2 1 ~ # { [ | ` \\ ^ @ ] } {b}",
		"{t} A Z \u20ac R T Y U I O P \u00a8 \u00a4",
		"Q S D F G H J K L M % \u00b5 {e}",
		"{s} > W X C V B N ? . / \u00a7 {s}",
		"{a} {alt} {space} {alt} {c}"
	]
};

$.keyboard.layouts['objt-international'] = {
	'default': [
		'` 1 2 3 4 5 6 7 8 9 0 - = {b}',
		'{t} q w e r t y u i o p [ ] \\',
		'a s d f g h j k l ; \' {e}',
		'{s} z x c v b n m , . / {s}',
		'{a} {alt} {space} {alt} {c}'
	],
	'shift': [
		'~ ! @ # $ % ^ & * ( ) _ + {b}',
		'{t} Q W E R T Y U I O P { } |',
		'A S D F G H J K L : " {e}',
		'{s} Z X C V B N M < > ? {s}',
		'{a} {alt} {space} {alt} {c}'
	],
	'alt': [
		'~ \u00a1 \u00b2 \u00b3 \u00a4 \u20ac \u00bc \u00bd \u00be \u2018 \u2019 \u00a5 \u00d7 {b}',
		'{t} \u00e4 \u00e5 \u00e9 \u00ae \u00fe \u00fc \u00fa \u00ed \u00f3 \u00f6 \u00ab \u00bb \u00ac',
		'\u00e1 \u00df \u00f0 f g h j k \u00f8 \u00b6 \u00b4 {e}',
		'{s} \u00e6 x \u00a9 v b \u00f1 \u00b5 \u00e7 > \u00bf {s}',
		'{a} {alt} {space} {alt} {c}'
	],
	'alt-shift': [
		'~ \u00b9 \u00b2 \u00b3 \u00a3 \u20ac \u00bc \u00bd \u00be \u2018 \u2019 \u00a5 \u00f7 {b}',
		'{t} \u00c4 \u00c5 \u00c9 \u00ae \u00de \u00dc \u00da \u00cd \u00d3 \u00d6 \u00ab \u00bb \u00a6',
		'\u00c4 \u00a7 \u00d0 F G H J K \u00d8 \u00b0 \u00a8 {e}',
		'{s} \u00c6 X \u00a2 V B \u00d1 \u00b5 \u00c7 . \u00bf {s}',
		'{a} {alt} {space} {alt} {c}'
	]
};

$.keyboard.layouts['objt-pad'] = {
	'default': [
		'q w e r t y u i o p {b}',
		'a s d f g h j k l {e}',
		'{s} z x c v b n m , . {s}',
		'{meta1} {space} {meta1} {a}'
	],
	'shift': [
		'Q W E R T Y U I O P {b}',
		'A S D F G H J K L {e}',
		'{s} Z X C V B N M ! ? {s}',
		'{meta1} {space} {meta1} {a}'
	],
	'meta1': [
		'1 2 3 4 5 6 7 8 9 0 {b}',
		'- / : ; ( ) \u20ac & @ {e}',
		'{meta2} . , ? ! \' " {meta2}',
		'{default} {space} {default} {a}'
	],
	'meta2': [
		'[ ] { } # % ^ * + = {b}',
		'_ \\ | ~ &lt; &gt; $ \u00a3 \u00a5 {e}',
		'{meta1} . , ? ! \' " {meta1}',
		'{default} {space} {default} {a}'
	]
};

if (typeof(language) === 'undefined') { var language = {}; };
language.pad = {
	display: {
		'default': 'ABC',
		'meta1'  : '.?123',
		'meta2'  : '#+='
	}
};

// This will replace all default language options with these language options.
$.extend(true, $.keyboard.defaultOptions, language.pad);

// Force enter to accept
$.keyboard.keyaction.enter = function(base){
    base.accept();      // accept the content
};

// default keyboard layout
keyboardLayout = 'objt-international';
