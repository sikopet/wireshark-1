#!/bin/sh
#
# Make-include - Creates a C include file (.h) of an ascii text
#
# To use the text in a GtkTextWidget, an annoying behaviour must be avoided.
# As the GtkTextWidget will ignore multiple line ends to indicate an empty line,
# a single space is prepended before every line end character '\n'.
#
# parameters:
# $1 C identifier prefix (e.g. test_section)
#
# Split the file every LINECOUNT lines so the strings don't become too long
# for some compilers.
LINECOUNT=400

# Create an #include'able version of this file
rm -f $1.h $1_tmp*
split -l $LINECOUNT $1.txt $1_tmp
NUM=0
echo "/* THIS FILE IS AUTOMATICALLY GENERATED, DO NOT MODIFY!!! */" >>$1.h
echo "const char *$1_part[] = {" >>$1.h
for i in $1_tmp*; do
   if [ $NUM -ne 0 ]; then
      echo "," >>$1.h
      echo >>$1.h
   fi
   sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/^/"/' -e 's/$/ \\n"/' <$i >>$1.h
   NUM=`expr $NUM + 1`
done
echo "};" >>$1.h

NAME_UPPER_PARTS=`echo $1_PARTS | tr '[:lower:]' '[:upper:]'`
echo "#define $NAME_UPPER_PARTS $NUM" >>$1.h
SIZE=`wc -c $1.txt | tr -d ' A-Za-z._-'`
NAME_UPPER_SIZE=`echo $1_SIZE | tr '[:lower:]' '[:upper:]'`
echo "#define $NAME_UPPER_SIZE $SIZE" >>$1.h
rm -f $1_tmp*

exit 0
