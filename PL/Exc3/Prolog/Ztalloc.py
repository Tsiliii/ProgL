import sys
import collections
import time

def success(Lin,Rin,Lout,Rout):
    return (Lin>=Lout and Rout>=Rin)

def conditions(Set,mid,ranger):
    if ranger == 0 or ranger == 1:
        temp = Set.get(mid)
        if temp!= None and temp <= ranger:
            return False
        else:
            return True
    for i in range (0,ranger-1):
        temp = Set.get(mid-i)
        if temp!= None and temp<ranger-i:
            return False
        temp = Set.get(mid+i)
        if temp!= None and temp < ranger -i:
            return False
    return True

def solver2(answer,Lin,Rin,Lout,Rout):
    tries = collections.deque()
    sum = 0
    answer = list()
    Set = {}
    mid = (Lin+Rin)//2
    range = Rin - mid
    Set.update({mid:range})
    while success(Lin,Rin,Lout,Rout) == False:
        L1 = Lin//2
        R1 = Rin//2
        mid1 = (L1+R1)//2
        range1 = R1 - mid1
        if (conditions(Set,mid1,range1)):
            copy1 = list(answer)
            copy1.append('h')
            Set.update({mid1:range1})
            tries.append((copy1,L1,R1))
        L2 = Lin*3+1
        R2 = Rin*3+1
        mid2 = (L2+R2)//2
        range2 = R2 - mid2
        if R2 <= 1000000:
            if (conditions(Set,mid2,range2)):
                answer.append('t')
                Set.update({mid2:range2})
                tries.append((answer,L2,R2))
        if tries:
            temp = tries.popleft()
            sum = sum +1
            answer,Lin,Rin = temp[0],temp[1],temp[2]
        else:
            return "IMPOSSIBLE"
    if answer == []:
        return "EMPTY"
    else:
        return "".join(answer)

def solver1(answer,Lin,Rin,Lout,Rout):
    tries = collections.deque()
    sum = 0
    answer = list()
    Set = {}
    mid = (Lin+Rin)//2
    range = Rin - mid
    Set.update({mid:range})
    while success(Lin,Rin,Lout,Rout) == False:
        sum = sum +1
        L1 = Lin//2
        R1 = Rin//2
        mid1 = (L1+R1)//2
        #print(mid)
        range1 = R1 - mid1
        temp = Set.get(mid1)
        if range1 > 50:
            check1 = (temp == None or temp > range1)
        else:
            check1 = (conditions(Set,mid1,range1))
        if (check1):
            copy1 = list(answer)
            copy1.append('h')
            Set.update({mid1:range1})
            tries.append((copy1,L1,R1))
        L2 = Lin*3+1
        R2 = Rin*3+1
        mid2 = (L2+R2)//2
        range2 = R2 - mid2
        temp = Set.get(mid2)
        if R2 <= 1000000:
            if range2 > 50:
                check2 = (temp == None or temp > range2)
            else:
                check2 = (conditions(Set,mid2,range2))
            if (check2):
                answer.append('t')
                Set.update({mid2:range2})
                tries.append((answer,L2,R2))
        if tries:
            temp = tries.popleft()
            answer,Lin,Rin = temp[0],temp[1],temp[2]
        else:
            print(sum)
            return "IMPOSSIBLE"
    if answer == []:
        print(sum)
        return "EMPTY"
    else:
        print(sum)
        return "".join(answer)

def main():
    if len(sys.argv) < 2:
        print("No File Given!")
        sys.exit()
    filename = sys.argv[1]
    file = open(filename, "r")
    if file.mode == 'r':
        Q = file.readline()
        for i in file.readlines():
            Lin , Rin , Lout , Rout = i.split()
            Lin = int(Lin)
            Rin = int(Rin)
            Lout = int(Lout)
            Rout = int(Rout)
            #print(Lin,Rin,Lout,Rout)
            print(solver1("",Lin,Rin,Lout,Rout))
        return

if __name__ == '__main__':
    main()
