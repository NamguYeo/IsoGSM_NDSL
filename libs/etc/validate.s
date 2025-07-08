inidate=$1
fhour=$2
yy=`expr $inidate / 1000000 `
mm=` expr $inidate / 10000 `
mm=` expr $mm % 100 `
dd=` expr $inidate / 100 `
dd=` expr $dd % 100 `
hh=` expr $inidate % 100 `
#save for print
y=$yy
m=$mm
d=$dd
h=$hh

#update hour
hx=` expr $hh + $fhour `
hh=` expr $hx % 24 `
fday=` expr $hx / 24 `

#update day, month and year together
dx=` expr $dd + $fday `
if [ $yy -lt 100 ];then yy=` expr 1900 + $yy `;fi
yx=` expr $yy % 4 `

# check day larger than maxima day of month #
while [ $dx -gt 28 ]
do
  if [ $mm -eq 2 ]
  then
      if [ $yx -eq 0 ]
      then
         dx=` expr $dx - 29 `
      else
         dx=` expr $dx - 28 `
      fi
      mm=` expr $mm + 1 `
  elif [ $mm -eq 1 -o $mm -eq 3 -o $mm -eq 5 -o $mm -eq 7 -o \
       $mm -eq 8 -o $mm -eq 10 -o $mm -eq 12 ]
  then
      dx=` expr $dx - 31 `
      mm=` expr $mm + 1 `
      if [ $mm -gt 12 ]
      then
          mm=` expr $mm - 12 `
          yy=` expr $yy + 1 `
          yx=` expr $yy % 4 `
      fi
  else
      dx=` expr $dx - 30 `
      mm=` expr $mm + 1 `
  fi
done

# check zero or negative day
while [ $dx -le 0 ]
do
  mm=` expr $mm - 1 `
  if [ $mm -eq 0 ]
  then
      mm=12
      yy=` expr $yy - 1 `
      if [ $yy -lt 100 ];then yy=` expr 1900 + $yy `;fi
#y2k      yy=` expr 1900 + $yy `
      yx=` expr $yy % 4 `
  fi
  if [ $mm -eq 2 ]
  then
      if [ $yx -eq 0 ]
      then
         dx=` expr $dx + 29 `
      else
         dx=` expr $dx + 28 `
      fi
  elif [ $mm -eq 1 -o $mm -eq 3 -o $mm -eq 5 -o $mm -eq 7 -o \
       $mm -eq 8 -o $mm -eq 10 -o $mm -eq 12 ]
  then
      dx=` expr $dx + 31 `
  else
      dx=` expr $dx + 30 `
  fi
done

# return day year from computing mode
dd=$dx
#y2kyy=` expr $yy % 100 `

#check values less than 10
#y2kif [ $yy -lt 10 ] 
#y2kthen
#y2k    yy=0$yy
#y2kfi
if [ $mm -lt 10 ] 
then
    mm=0$mm
fi
if [ $dd -lt 10 ] 
then
    dd=0$dd
fi
if [ $hh -lt 10 ] 
then
    hh=0$hh
fi
if [ $y -lt 10 ] 
then
    y=0$y
fi
if [ $m -lt 10 ] 
then
    m=0$m
fi
if [ $d -lt 10 ] 
then
    d=0$d
fi
if [ $h -lt 10 ] 
then
    h=0$h
fi
echo $yy$mm$dd$hh
echo " Input with year=$y, month=$m, day=$d, hour=$h "
echo " and fcsthour=$fhour "
echo " Validate  at year=$yy, month=$mm, day=$dd, hour=$hh "
