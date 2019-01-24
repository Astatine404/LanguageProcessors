#include<iostream>
#include<bits/stdc++.h>
using namespace std;

string input, start, tmpstr; int N, L;
vector<string> prodl, prodr;

void parse(vector<vector<string> > &m, string curr, vector<vector<string> > &results){
	string next;
	for(int i=L-1; i>=0; i--){
		for(int j=0; j<L-i; j++){
			if(m[i][j]=="X")
				continue;
				
			//find m[i][j] in curr
			bool found = false;
			for(int p=0; p<curr.size(); p++){
				for(int q=0; q<m[i][j].size(); q++){
					if(curr[i]==m[i][j][q]){
						found = true;
						//find m[i][j][q] in prodl
						int target
						next.clear();
						for(int k=0; k<i; k++)
							next.push_back(curr[k]);	
						
					}
				}
			}
		}
	}
}


int main(){
	cout<<"Enter input string: ";
	cin>>input;
	cout<<"Enter start symbol: ";
	cin>>start;
	cout<<"No. of productions: "; cin>>N;
	cout<<"Enter productions: \n";
	for(int i=0; i<N; i++){
		cin>>tmpstr;
		prodl.push_back(tmpstr);
		cin>>tmpstr;
		prodr.push_back(tmpstr);
	}
	cout<<endl;
	
	//Make the CYK Matrix
	vector<string> tmp(input.size(), "X");
	vector<vector<string> > m(input.size(), tmp);
	L = input.size();
	
	//Fill bottom row
	string lhs;
	for(int i=0; i<L; i++){
		//Find corresponding lhs in prod where input char=rhs
		lhs.clear();
		string terminal(1, input[i]);
		for(int j=0; j<prodr.size(); j++){
			if(prodr[j]==terminal){
				lhs = lhs + prodl[j];
			} 
		}
		if(lhs.empty()){
			cout<<"Error!";
			return 1;
		}
		cout<<lhs<<" ";
		m[0][i] = lhs;
	}
	cout<<endl;
	
	vector<string> terms;
	//start filling rows of matrix
	for(int i=1; i<L; i++){
		for(int j=0; j<L-i; j++){
			//selected the cell
			//traverse diagonal and column
			vector<string> result; string tmp;
			for(int ctr=0; ctr<i; ctr++){
				string col = m[ctr][j], diag = m[i-ctr-1][j+ctr+1];
				if(col=="X"||diag=="X")
					//nothing to do
					;
				else{
					//multiply col and diag
					for(int p=0; p<col.size(); p++){
						for(int q=0; q<diag.size(); q++){
							tmp.clear();
							tmp.push_back(col[p]);
							tmp.push_back(diag[q]);
							result.push_back(tmp);
						}
					}
				}
			}
			//check result to rule
			for(int p=0; p<prodr.size(); p++){
				for(int q=0; q<result.size(); q++){
					if(result[q]==prodr[p]){
						if(m[i][j] == "X")
							m[i][j].clear();
						m[i][j] = m[i][j] + prodl[p];
					}
				}
			}
			
			//print the element
			cout<<m[i][j]<<" ";
		}
		cout<<endl;
	}
	
	//check if top contains start symbol
	if(m[L-1][0]==start)
		cout<<"Given string is a member\n";
	else
		cout<<"Given string is NOT a member\n";
	
	vector<vector<string> > result;
	//generating parse tree
	parse(m, start, result);
		
	return 0;
	
}
