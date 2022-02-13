d1 = {
    "manu" : 9,
    "theo" : 1,
    "atlas" : 3,
    "nico" : 15,
    "mihaita" : 19,
    "robi" : 2,
    "barni" : 16,
    "vio" : 22,
    "klaus" : 38,
    "pace" : 100
}

d2 = {
    "mario" : 0,
    "atlas" : 5,
    "opio" : 8,
    "theo" : 9,
    "manu": 1,
    "porci": 91,
    "klaus": 0
}

d= {}

for k in d1.keys():
    if k in d2.keys() and k not in d.keys():
        d [k] = d1 [k] + d2 [k]
    elif k not in d.keys():
        d [k] = d1 [k]

for k in d2.keys():
    if k not in d.keys():
        d [k] = d2 [k]

print (d)