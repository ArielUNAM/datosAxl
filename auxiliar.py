import pandas as pd
import matplotlib.pyplot as plt

path2save = "./data/transfData/"
df = pd.read_csv("./data/base.csv") 

lyears = list(range(2000,2021))  
lvar = ["TMP","CO","NOX","PM2.5","SO2"]

for var in lvar:
    for year in lyears:
        lval = [0 for i in range(len(df.cve_estac))]
        try:
            promY = pd.read_csv("data/transfData/{}_{}.csv".format(year,var))
            for station in promY['station']:
                lval[df.index[df['cve_estac'] == station][0]] = promY['mean'][promY['station'] == station].values[0]
            df[year] = lval
        except:
            continue
    df.to_csv("{}{}.csv".format(path2save,var),index=False) 
