//File:Input.java
import java.io.*;
import java.util.*;

public class SaveTheCat {

    public static class coord{
        public int x;
        public int y;
        public int t;

        public coord(int a,int b,int c){
            x=a; y=b; t=c;
        }

        public int get_x(){
            return x;
        }
        public int get_y(){
            return y;
        }
        public int get_t(){
            return t;
        }
    }

    public static String Answer (char board[][], int ti, int tj){
        String answer = "";
            while((board[ti][tj]!= 'a' && board[ti][tj]!= 'A' )){
                char temp = board[ti][tj];
                if (board[ti][tj] >= 'a' && board[ti][tj] <= 'z'){
                    temp = Character.toUpperCase(temp);
                }
                if(temp == 'D'){
                    ti--;
                }
                else if(temp == 'U'){
                    ti++;
                }
                else if(temp == 'R'){
                    tj--;
                }
                else if(temp == 'L'){
                    tj++;
                }
                answer = temp + answer;
            }
        return answer;
    }

    public static void min_pos(int result [], char board[][], int M, int N){
        for (int i=0; i<M; i++){
            for (int j=0; j<N; j++){
                if(is_cat(board[i][j])) {
                    result[0] = i;
                    result[1] = j;
                    return;
                }
            }
        }
    }

    public static void Min_pos(int result [], char board[][],int timed[][], int M, int N,int T){
        for (int i=0; i<M; i++){
            for (int j=0; j<N; j++){
                if(were_cat(board[i][j]) && timed[i][j]==T-2) {
                    result[0] = i;
                    result[1] = j;
                    return;
                }
            }
        }
    }

    public static void Printer(char Board [][],int N,int M){
        for(int i = 0; i < M; i++){
            for(int j = 0; j < N; j++){
                System.out.print((Board[i][j]));
            }
            System.out.println();
        }
        System.out.println();
    }

    public static boolean is_cat(char a){
        if (a == 'A' || a == 'L' || a == 'R' || a == 'U' || a == 'D')
            return true;
        return false;
    }

    public static boolean were_cat(char a){
        if (a == 'a' || a == 'l' || a == 'r' || a == 'u' || a == 'd')
            return true;
        return false;
    }

    public static boolean is_water(char a){
        if ( a == 'W' || a == 'l' || a == 'r' || a == 'u' || a == 'd' || a == 'a')
            return true;
        return false;
    }

    public static char conflict(char a, char b){
        if(a>b)
            return a;
        return b;
    }

    public static boolean update_cat (char board [][],int timed [][],int bs [] ,int I,int J,int T,int N,int M,Stack <coord> c,int cats[]){
        boolean cat=false;
        if(J!=0){
            if(board[I][J-1] == '.' ){
                coord temp1 = new coord(I,J-1,T);
                board[I][J-1] = 'L';
                timed[I][J-1] = T;
                c.push(temp1);
                cats[0]++;
                bs[0]++;
                cat = true;
            }
            else if(is_cat(board[I][J-1])){
                if (timed[I][J-1] == T){
                    board[I][J-1] = conflict(board[I][J-1],'L');
                }
            }
        }
        if(J!=N-1){
            if(board[I][J+1] == '.'){
                coord temp1 = new coord(I,J+1,T);
                board[I][J+1] = 'R';
                timed[I][J+1] = T;
                c.push(temp1);
                cats[0]++;
                bs[0]++;
                cat = true;
            }
            else if(is_cat(board[I][J+1])){
                if (timed[I][J+1] == T){
                    board[I][J+1] = conflict(board[I][J+1],'R');
                }
            }
        }
        if(I!=0){
            if(board[I-1][J] == '.'){
                coord temp1 = new coord(I-1,J,T);
                board[I-1][J] = 'U';
                timed[I-1][J] = T;
                c.push(temp1);
                cats[0]++;
                bs[0]++;
                cat = true;
            }
            else if(is_cat(board[I-1][J])){
                if (timed[I-1][J] == T){
                    board[I-1][J] = conflict(board[I-1][J],'U');
                }
            }
        }
        if(I!=M-1){
            if(board[I+1][J] == '.'){
                coord temp1 = new coord(I+1,J,T);
                board[I+1][J] = 'D';
                timed[I+1][J] = T;
                c.push(temp1);
                cats[0]++;
                bs[0]++;
                cat = true;
            }
            else if(is_cat(board[I+1][J])){
                if (timed[I+1][J] == T){
                    board[I+1][J] = conflict(board[I+1][J],'D');
                }
            }
        }
        return cat;
    }

    public static void update_water (char board [][],int timed [][],int bs [], int I,int J,int T,int N,int M,Stack <coord> w,int cats []){
        if(J!=0){
            if(board[I][J-1] == '.' || is_cat(board[I][J-1])){
                if(is_cat(board[I][J-1])){
                    cats[0]--;
                    bs[0]--;
                    bs[1]++;
                    board[I][J-1] = Character.toLowerCase(board[I][J-1]);
                    timed[I][J-1] = T;
                }
                else{
                    bs[1]++;
                    board[I][J-1] = 'W';
                    timed[I][J-1] = T;
                }
                coord temp1 = new coord(I,J-1,T);
                w.push(temp1);
            }
        }
        if(J!=N-1){
            if(board[I][J+1] == '.' || is_cat(board[I][J+1])){
                if(is_cat(board[I][J+1])){
                    cats[0]--;
                    bs[0]--;
                    bs[1]++;
                    board[I][J+1] = Character.toLowerCase(board[I][J+1]);
                    timed[I][J+1] = T;
                }
                else{
                    bs[1]++;
                    board[I][J+1] = 'W';
                    timed[I][J+1] = T;
                }
                coord temp1 = new coord(I,J+1,T);
                w.push(temp1);
            }
        }
        if(I!=0){
            if(board[I-1][J] == '.' || is_cat(board[I-1][J])) {
                if(is_cat(board[I-1][J])){
                    cats[0]--;
                    bs[0]--;
                    bs[1]++;
                    board[I-1][J] = Character.toLowerCase(board[I-1][J]);
                    timed[I-1][J] = T;
                }
                else{
                    bs[1]++;
                    board[I-1][J] = 'W';
                    timed[I-1][J] = T;
                }
                coord temp1 = new coord(I-1,J,T);
                w.push(temp1);
            }
        }
        if(I!=M-1){
            if(board[I+1][J] == '.' || is_cat(board[I+1][J])) {
                if(is_cat(board[I+1][J])){
                    cats[0]--;
                    bs[0]--;
                    bs[1]++;
                    board[I+1][J] = Character.toLowerCase(board[I+1][J]);
                    timed[I+1][J] = T;
                }
                else{
                    bs[1]++;
                    board[I+1][J] = 'W';
                    timed[I+1][J] = T;
                }
                coord temp1 = new coord(I+1,J,T);
                w.push(temp1);
            }
        }
    }

    public static void main(String [] args) {
        try{
            BufferedReader in = new BufferedReader(new FileReader(args[0]));
            String line;
            int N,M;
            char [][] Board = new char[1000][1000];
            int [][] Timed = new int[1000][1000];
            N = 0; M = 0;
            int [] Miinimum_positions =  new int[2];
            char temp;
            int [] cats = new int[1];
            cats[0] = 0;
            Stack <coord> c1 = new Stack<coord>();
            Stack <coord> c2 = new Stack<coord>();
            Stack <coord> w1 = new Stack<coord>();
            Stack <coord> w2 = new Stack<coord>();
            int [] Bs = new int[2]; Bs[0] = 0; Bs[1] = 0;
            int [] prev = new int[2]; prev[0]=0; prev[1]=0;
            boolean play = true;
            boolean check = true;
            boolean Stop = true;
            int time = 1;
            while ((line = in.readLine()) != null) {
                if (M == 0){
                    N = line.length();
                }
                for (int i=0; i<N; i++){
                    temp = line.charAt(i);
                    Board[M][i] = temp;
                    Timed[M][i] = 0;
                    if(temp == 'W'){
                        coord temp1= new coord(M,i,0);
                        Bs[1]++;
                        prev[1]++;
                        w1.push(temp1);
                    }
                    else if (temp == 'A'){
                        coord temp1 = new coord(M,i,0);
                        cats[0] = 1;
                        Bs[0]++;
                        c1.push(temp1);
                    }
                }
                M++;
            }
            in.close ();
            while(true){
                coord temp1 = new coord(-1,-1,-1);
                boolean A = false;
                Stop = true;
                if((time+1)%2==0){
                    while(!c1.empty()){
                        temp1 = c1.pop();
                        A = update_cat(Board,Timed,Bs,temp1.get_x(),temp1.get_y(),time,N,M,c2,cats);
                        if(A){
                            Stop = false;
                        }
                    }
                    while(!w1.empty()){
                        temp1 = w1.pop();
                        update_water(Board,Timed,Bs,temp1.get_x(),temp1.get_y(),time,N,M,w2,cats);
                    }
                }
                else{
                    while(!c2.empty()){
                        temp1 = c2.pop();
                        A = update_cat(Board,Timed,Bs,temp1.get_x(),temp1.get_y(),time,N,M,c1,cats);
                        if(A){
                            Stop = false;
                        }
                    }
                    while(!w2.empty()){
                        temp1 = w2.pop();
                        update_water(Board,Timed,Bs,temp1.get_x(),temp1.get_y(),time,N,M,w1,cats);
                    }
                }
                Printer(Board,N,M);
                //System.out.println("cats = " + cats[0] + ", prev = " + prev[0] + "," + prev[1] + ", Bs = " + Bs[0] + ", " + Bs[1] + " Play = " + play + ", Stop = " + Stop + ", Time = " + time);
                time++;
                if(!play){
                    break;
                }
                if(c1.empty() && c2.empty() && (prev[1]==Bs[1] || cats[0]==0)){
                    play = false;
                    continue;
                }
                else if(Stop &&  prev[0]==Bs[0] ){
                    play = false;
                    continue;
                }
                else{
                    prev[0]=Bs[0];
                    prev[1]=Bs[1];
                    }
                }
                if(Bs[0]!=0){
                    min_pos(Miinimum_positions, Board, M, N);
                    //System.out.println(Miinimum_positions[0] + " " + Miinimum_positions[1]);
                    System.out.println("infinity");
                    if(Board[Miinimum_positions[0]][Miinimum_positions[1]]=='A'){
                        System.out.println("stay");
                    }
                    else{
                        System.out.println(Answer(Board,Miinimum_positions[0],Miinimum_positions[1]));
                    }
                }
                else{
                    Min_pos(Miinimum_positions, Board,Timed, M, N,time);
                    System.out.println(time-3);
                    if(Board[Miinimum_positions[0]][Miinimum_positions[1]]=='A'){
                        System.out.println("stay");
                    }
                    else{
                        System.out.println(Answer(Board,Miinimum_positions[0],Miinimum_positions[1]));
                }
                return;
                }
            }
            catch(IOException e) {
                e.printStackTrace ();
            }
        }
    }
