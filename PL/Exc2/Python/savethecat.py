#!/usr/bin/python

import sys

def help():
    print('A')

def printBoard(Fancyarr,N):
    for x,y in Fancyarr:
        print(Fancyarr[x,y], end = "")
        if y == N-1:
            print()

def main():
    with open(str(sys.argv[1]), "r") as file_handle:
        K = 0
        cats = 0
        waters = 0
        catstack = []
        updatestack = []
        minPos = (1001,1001)
        time = 0
        play = True
        Fancyarr = {}
        for line in file_handle:
            if K == 0 :
                N = len(line) - 1
            for i in range(0,N):
                temp = line[i]
                if temp == 'A':
                    catstack.append((K,i))
                    cats = 1
                elif temp == 'W' :
                    waters == waters + 1
                Fancyarr.update({(K,i):(temp,0)})
            K = K + 1
        i=0
        while play == True :
            Stop = True
            for i in range 0 , M :
                for j in range 0 , N :

if __name__== "__main__":
    main()
