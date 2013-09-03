
all:
	stylus *.styl
	mv *.css css/
	coffee -c *.coffee
	mv *.js js/
