def isleap (year):
    if year % 4 != 0:
        leap = False
    elif year % 100 != 0:
        leap = True
    elif year % 400 != 0:
        leap = False
    else:
        leap = True
    return leap

month_no_days = {
    "Jan" : 31,
    "Feb_leap" : 29,
    "Feb_common" : 28,
    "Mar" : 31,
    "Apr" : 30,
    "May" : 31,
    "Jun" : 30,
    "Jul" : 31,
    "Aug" : 31,
    "Sep" : 30,
    "Oct" : 31,
    "Nov" : 30,
    "Dec" : 31,
}
week_days = ["Luni", "Marti", "Miercuri",  "Joi", "Vineri", "Sambata",  "Duminica"]
year_months = ["Jan", "Feb_leap", "Feb_common", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
month_day = 1
month = 0
year = 1702
day = 6
leap = False

date = input ("Data: ")
a = date.split ()
fin_month_day = int(a[0])
fin_month = int(a[1])
fin_year = int(a[2])

leap_fin_year =  isleap(fin_year)
if fin_month == 1:
    fin_month = 0
elif fin_month == 2:
    if (leap_fin_year == True):
        fin_month = 1
    else:
        fin_month = 2

while month_day < fin_month_day or month < fin_month or year < fin_year:
    if month_day < month_no_days[year_months[month]]:
        month_day += 1
        if day == 6:
            day = 0
        else:
            day += 1
    else:
        if month == 12:
            month = 0
            year += 1
            leap = isleap (year)
        elif month >= 2:
            month += 1
        elif month == 1:
            month += 2
        elif leap == True:
            month += 1
        else:
            month += 2

        month_day = 1
        if day == 6:
            day = 0
        else:
            day += 1

print ("Data respectiva a picat in ziua de", week_days[day])

