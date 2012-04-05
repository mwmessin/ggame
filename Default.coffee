
@Default = {
	beings: {
		'z': {
			spritemap: 'imgs/z.png',
			width: 24,
			height: 24,
			dimensions: [12, 12],
			offset: [6, 0],
			animations: {
				'walkDown': {
					frames: [[0,0], [24,0, 200], [48,0, 300], [72,0, 400], [96,0, 600], [120,0, 800], [144,0, 1000]],
					extrap: 'loop'
				},
				'walkLeft': {
					frames: [[504,0], [528,0, 200], [552,0, 300], [576,0, 400], [600,0, 600], [624,0, 800], [648,0, 1000]],
					extrap: 'loop'
				},
				'walkRight': {
					frames: [[336,0], [360,0, 200], [384,0, 300], [408,0, 400], [432,0, 600], [456,0, 800], [480,0, 1000]],
					extrap: 'loop'
				},
				'walkUp': {
					frames: [[168,0], [192,0, 200], [216,0, 300], [240,0, 400], [264,0, 600], [288,0, 800], [312,0, 1000]],
					extrap: 'loop'
				}
			}
		},
		'bigtree': {
			spritemap: 'imgs/bigtree.png',
			width: 72,
			height: 72,
			dimensions: [24, 8],
			offset: [24, 0],
			animations: {
				'sit': {
					frames: [[0,0]]
				}
			}
		},
		'rock': {
			spritemap: 'imgs/rock.png',
			width: 24,
			height: 24,
			dimensions: [24, 20],
			animations: {
				'sit': {
					frames: [[0,0]]
				}
			}
		}
	},
	tiles: {
		'dirt': {
			spritemap: 'imgs/ground.png',
			width: 24,
			height: 24,
			orientations: {
				'topleft': [0,0],
				'bottomright': [24,0],
				'bottomleft': [48,0],
				'topright': [72,0],
				'top': [0,24],
				'right': [24,24],
				'bottom': [48,24],
				'left': [72,24],
				'normal': [0,48],
				'island': [24,48],
				'vertical': [48,48],
				'horizontal': [72,48],
				'tipbottom': [0,72],
				'tipleft': [24,72],
				'tiptop': [48,72],
				'tipright': [72,72],
				'wallbottomleft': [96,48],
				'wall': [120,48],
				'wallbottomright': [168,48],
				'slopeleft': [96,0],
				'wallleft': [96,24],
				'sloperight': [168,0],
				'wallright': [168,24],
				'wallboth': [144,24],
				'twinpeaks': [144,0],
				'column': [120,24],
				'cheeks': [144,48],
				'columnleft': [96,72],
				'columnright': [120,72],
				'clifftoprightbottom': [120,72]
			}
		}
	},
	items: {
		
	},
	levels: [
		{
			name: 'test',
			grid: [
				[{name: 'dirt', z: 0}, null],
				[{name: 'dirt', z: 0}, {name: 'dirt', z: 0}]
			],
			beings: [
				{
					kind: 'z',
					owner: 0,
					location: [24,24]
				},
				{
					kind: 'z',
					owner: 1,
					location: [48,24]
				},
				{
					kind: 'bigtree',
					location: [48,48]
				},
				{
					kind: 'bigtree',
					location: [0,72]
				},
				{
					kind: 'bigtree',
					location: [84,12]
				},
				{
					kind: 'rock',
					location: [0,12]
				}
			]
		}
	]
}