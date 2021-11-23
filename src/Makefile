
scf4: luser
	alacritty --hold --command ./luser

scf5:
	echo "shortcut F5"

dotprod: dotprod.h

dotprod.h: dotprod.fut
	futhark opencl --library dotprod.fut

libdotprod.so: dotprod.h
	gcc dotprod.c -o libdotprod.so -fPIC -shared
	cp libdotprod.so lib
	

# luser: luser.hs libdotprod.so
# 	ghc luser.hs -L. -L$(OPENCL_LIB_PATH) -ldotprod -lOpenCL
# 	# ghc luser.hs -L. -ldotprod -lOpenCL
	
luser: luser.hs libdotprod.so dotprod.h
	ghc luser.hs -L$(OPENCL_LIB_PATH) -lOpenCL dotprod.h dotprod.c

clean:
	rm *.o exe *.h dotprod.c dotprod dotprod.json libdotprod.so luser *.hi
