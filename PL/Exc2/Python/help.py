#!/usr/bin/python

import sys

Bs0 = 0
Bs1 = 0
cats = 1

def Answer(Fancyarr,i,j):
    answer=""
    while Fancyarr[i,j][0] != 'A' and Fancyarr[i,j][0] != 'a':
        if Fancyarr[i,j][0] >= 'a' and Fancyarr[i,j][0] <= 'z':
            temp = Fancyarr[i,j][0].upper()
        else:
            temp = Fancyarr[i,j][0]
        if temp == 'D':
            i = i - 1
        elif temp == 'U':
            i = i + 1
        elif temp == 'R':
            j = j - 1
        elif temp == 'L':
            j = j + 1
        answer = temp + answer;
    return answer

def min_pos(Fancyarr,M,N):
    for i in range (0,M):
        for j in range (0,N):
            if is_cat(Fancyarr[i,j][0]):
                return (i,j)

def Min_pos(Fancyarr,M,N,T):
    for i in range (0,M):
        for j in range (0,N):
            if were_cat(Fancyarr[i,j][0]) and Fancyarr[i,j][1]==T-1:
                return (i,j)

def is_cat(a):
    if (a == 'A' or a == 'L' or a == 'R' or a == 'U' or a == 'D'):
        return True
    return False


def were_cat(a):
    if (a == 'a' or a == 'l' or a == 'r' or a == 'u' or a == 'd'):
        return True
    return False


def is_water(a):
    if ( a == 'W' or a == 'l' or a == 'r' or a == 'u' or a == 'd' or a == 'a'):
        return True
    return False


def conflict(a,b):
    if(a>b):
        return a
    return b

def update_cat (Fancyarr,I,J,T,N,M,c):
    global Bs0,Bs1
    global cats
    cat=False
    if J!=0:
        if Fancyarr[I,J-1][0] == '.':
            Fancyarr.update({(I,J-1):('L',T)})
            c.append((I,J-1,T))
            cats = cats + 1
            Bs0 = Bs0 + 1
            cat = True
        elif(is_cat(Fancyarr[I,J-1][0]) and Fancyarr[I,J-1][1] == T):
            Fancyarr.update({(I,J-1):(conflict(Fancyarr[I,J-1][0],'L'),T)})
    if J!=N-1:
        if Fancyarr[I,J+1][0] == '.':
            Fancyarr.update({(I,J+1):('R',T)})
            c.append((I,J+1,T))
            cats = cats + 1
            Bs0 = Bs0 + 1
            cat = True
        elif(is_cat(Fancyarr[I,J+1][0]) and Fancyarr[I,J+1][1] == T):
            Fancyarr.update({(I,J+1):(conflict(Fancyarr[I,J+1][0],'R'),T)})
    if I!=0:
        if Fancyarr[I-1,J][0] == '.':
            Fancyarr.update({(I-1,J):('U',T)})
            c.append((I-1,J,T))
            cats = cats + 1
            Bs0 = Bs0 + 1
            cat = True
        elif(is_cat(Fancyarr[I-1,J][0]) and Fancyarr[I-1,J][1] == T):
            Fancyarr.update({(I-1,J):(conflict(Fancyarr[I-1,J][0],'U'),T)})
    if I!=M-1:
        if Fancyarr[I+1,J][0] == '.':
            Fancyarr.update({(I+1,J):('D',T)})
            c.append((I+1,J,T))
            cats = cats + 1
            Bs0 = Bs0 + 1
            cat = True
        elif(is_cat(Fancyarr[I+1,J][0]) and Fancyarr[I+1,J][1] == T):
            Fancyarr.update({(I+1,J):(conflict(Fancyarr[I+1,J][0],'D'),T)})
    return cat

def update_water (Fancyarr,I,J,T,N,M,w):
    global Bs0,Bs1
    global cats
    if J!=0:
        if Fancyarr[I,J-1][0] == '.' or is_cat(Fancyarr[I,J-1][0]):
            if(is_cat(Fancyarr[I,J-1][0])):
                cats = cats - 1
                Bs0 = Bs0 - 1
                Bs1 = Bs1 + 1
                Fancyarr.update({(I,J-1):(Fancyarr[I,J-1][0].lower(),T)})
            else:
                Bs1 = Bs1 + 1
                Fancyarr.update({(I,J-1):('W',T)})
            w.append((I,J-1,T))
    if J!=N-1:
        if Fancyarr[I,J+1][0] == '.' or is_cat(Fancyarr[I,J+1][0]):
            if(is_cat(Fancyarr[I,J+1][0])):
                cats = cats - 1
                Bs0 = Bs0 - 1
                Bs1 = Bs1 + 1
                Fancyarr.update({(I,J+1):(str(Fancyarr[I,J+1][0]).lower(),T)})
            else:
                Bs1 = Bs1 + 1
                Fancyarr.update({(I,J+1):('W',T)})
            w.append((I,J+1,T))
    if I!=0:
        if Fancyarr[I-1,J][0] == '.' or is_cat(Fancyarr[I-1,J][0]):
            if(is_cat(Fancyarr[I-1,J][0])):
                cats = cats - 1
                Bs0 = Bs0 - 1
                Bs1 = Bs1 + 1
                Fancyarr.update({(I-1,J):(Fancyarr[I-1,J][0].lower(),T)})
            else:
                Bs1 = Bs1 + 1
                Fancyarr.update({(I-1,J):('W',T)})
            w.append((I-1,J,T))
    if I!=M-1:
        if Fancyarr[I+1,J][0] == '.' or is_cat(Fancyarr[I+1,J][0]):
            if(is_cat(Fancyarr[I+1,J][0])):
                cats = cats - 1
                Bs0 = Bs0 - 1
                Bs1 = Bs1 + 1
                Fancyarr.update({(I+1,J):(Fancyarr[I+1,J][0].lower(),T)})
            else:
                Bs1 = Bs1 + 1
                Fancyarr.update({(I+1,J):('W',T)})
            w.append((I+1,J,T))

def printBoard(Fancyarr,N):
    for x,y in Fancyarr:
        print(Fancyarr[x,y][0], end = "")
        if y == N-1:
            print()
    print()
    for x,y in Fancyarr:
        print(Fancyarr[x,y][1], end = "")
        if y == N-1:
            print()
    print()
    return

def main():
    with open(str(sys.argv[1]), "r") as file_handle:
        c1,c2,w1,w2 = [],[],[],[]
        global Bs0
        Bs0 = 0
        global Bs1
        Bs1 = 0
        Prev0 = 0
        Prev1 = 0
        waters = 0
        Fancyarr = {}
        play = True
        check = True
        Stop = True
        global cats
        N = 0
        M = 0
        time = 1
        for line in file_handle:
            #print(len(line))
            if M == 0 :
                N = len(line) - 1
            for i in range(0,N):
                temp = line[i]
                if temp == 'A':
                    c1.append((M,i,0))
                    cats = 1
                    Bs0 = Bs0 + 1
                elif temp == 'W' :
                    waters == waters + 1
                    Bs1 = Bs1 + 1
                    Prev1 = Prev1 + 1
                    w1.append((M,i,0))
                Fancyarr.update({(M,i):(temp,0)})
            M = M + 1
        while play == True :
            if ((time+1)%2 == 0):
                while c1:
                    temp = c1.pop()
                    A = update_cat(Fancyarr,temp[0],temp[1],time,N,M,c2)
                    if A == True:
                        Stop = False
                while w1:
                    temp = w1.pop()
                    update_water(Fancyarr,temp[0],temp[1],time,N,M,w2)
            else :
                while c2:
                    temp = c2.pop()
                    A = update_cat(Fancyarr,temp[0],temp[1],time,N,M,c1)
                    if A == True:
                        Stop = False
                while w2:
                    temp = w2.pop()
                    update_water(Fancyarr,temp[0],temp[1],time,N,M,w1)
            time = time + 1
            if play == False:
                break
            if c1 == [] and c2 == [] and (Prev1 == Bs1 or cats==0):
                play = False
                continue
            elif Stop == True and Prev0 == Bs0:
                play = False
                continue
            else:
                Prev0=Bs0
                Prev1=Bs1
    if Bs0!=0:
        Ans = min_pos(Fancyarr,M,N)
        print("infinity")
        if Fancyarr[Ans[0],Ans[1]][0] == 'A':
            print("stay")
        else:
            print(Answer(Fancyarr,Ans[0],Ans[1]))
    else:
        Ans = Min_pos(Fancyarr,M,N,time)
        print(time-2)
        if Fancyarr[Ans[0],Ans[1]][0] == 'A':
            print("stay")
        else:
            print(Answer(Fancyarr,Ans[0],Ans[1]))
    return

if __name__== "__main__":
    main()
