#include <iostream>
#include <bits/stdc++.h>
using namespace std;

struct production {
	char lhs;
	string rhs;
	int ptr;
};

bool operator==(struct production const &p, struct production const &q){
	return (p.lhs==q.lhs)&&(p.rhs==q.rhs)&&(p.ptr==q.ptr);
}

bool operator==(vector<struct production> const &p, vector<struct production> const &q){
	if(p.size()!=q.size())
		return false;
	for(int i=0; i<p.size(); i++){
		if(!(p[i]==q[i]))
			return false;
	}
	return true;
}

int find(vector<struct production> &items, struct production q){
	for(int i=0; i<items.size(); i++){
		if(items[i]==q)
			return i;
	}
	return -1;
}

int N=0, setctr=0;
vector<struct production> prod;
struct production tmp;
map<char, string> tmp2;
vector<vector<struct production> > itemsets(100, prod);
vector<map<char, string> > table(100, tmp2);


void print(){
	for(int i=0; i<itemsets.size(); i++){
		if(itemsets[i].size()==0) break;
		cout<<"I"<<i<<endl;
		for(int j=0; j<itemsets[i].size(); j++){
			cout<<itemsets[i][j].lhs<<" --> ";
			for(int k=0; k<itemsets[i][j].ptr; k++)
				cout<<itemsets[i][j].rhs[k];
			cout<<".";
			for(int k=itemsets[i][j].ptr; k<itemsets[i][j].rhs.size(); k++)
				cout<<itemsets[i][j].rhs[k];
			cout<<endl;
		}
		cout<<endl;
	}
}

void printtable(){
	cout<<"   ";
	for(auto it=table[0].begin(); it!=table[0].end(); it++){
		cout<<it->first<<" ";
		for(int i=0; i<=setctr; i++){
			if(table[i].find(it->first)==table[i].end())
				table[i][it->first] = " ";
		}
	}
	cout<<endl;
	for(int i=0; i<=setctr; i++){
		cout<<"I"<<i<<" ";
		for(auto it=table[i].begin(); it!=table[i].end(); it++){
			cout<<it->second<<" ";
		}
		cout<<endl;
	}
}

void closure(vector<struct production> &items){
	for(int i=0; i<items.size(); i++){
		if(items[i].ptr>=items[i].rhs.size())
			break;
		//find ptr pos in main list
		for(int j=0; j<prod.size(); j++){
			if(prod[j].lhs == (items[i].rhs)[items[i].ptr]){
				//add to set if not already
				if(find(items, prod[j])<0)
					items.push_back(prod[j]);
			}
		}
	}
}

void creategoto(vector<struct production> &items, int pos){
	for(int i=0; i<items.size(); i++){
		if(items[i].ptr>=items[i].rhs.size())
			break;
		//create new set
		setctr++;
		
		itemsets[setctr].push_back(items[i]);
		itemsets[setctr].back().ptr++;
		closure(itemsets[setctr]);
		//check if already present
		int flag=0;
		for(int j=0; j<setctr; j++){
			if(itemsets[j]==itemsets[setctr]){
				cout<<"goto (I"<<pos<<", "<<items[i].rhs[items[i].ptr]<<") repeats I"<<j<<endl;
				if(islower(items[i].rhs[items[i].ptr])){
					string tstr = "S" + to_string(j);
					table[pos][items[i].rhs[items[i].ptr]] = tstr;
				}
				else{
					string tstr = to_string(j);
					table[pos][items[i].rhs[items[i].ptr]] = tstr;
				}
				itemsets[setctr].clear();
				setctr--;
				flag=1;
				break;
			}
		}
		if(flag==1) break;
		cout<<"goto (I"<<pos<<", "<<items[i].rhs[items[i].ptr]<<") creates I"<<setctr<<endl;
		if(islower(items[i].rhs[items[i].ptr])){
			string tstr = "S" + to_string(setctr);
			table[pos][items[i].rhs[items[i].ptr]] = tstr;
		}
		else{
			string tstr = to_string(setctr);
			table[pos][items[i].rhs[items[i].ptr]] = tstr;
		}
		creategoto(itemsets[setctr], setctr);
	}
}

int main(){
	cout<<"No. of productions: "; cin>>N;
	cout<<"Enter productions: \n";
	for(int i=0; i<N; i++){
		cin>>tmp.lhs;
		cin>>tmp.rhs;
		tmp.ptr = 0;
		prod.push_back(tmp);
	}
	//initialize I0 by augmented prod
	tmp.lhs = 'X';
	tmp.rhs = "S";
	tmp.ptr = 0;
	itemsets[0].push_back(tmp);
	closure(itemsets[0]);
	creategoto(itemsets[0], 0);
	print();
	printtable();

	return 0;

}