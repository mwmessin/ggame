
all:
	coffee -c *.coffee
	mv *.js js/
	stylus *.styl
	mv *.css css/
