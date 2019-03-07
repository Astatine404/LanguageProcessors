#include<iostream>
#include<bits/stdc++.h>
using namespace std;

char s;

void useless(map<char, vector<string> > &prod, set<char> &useful, char symbol){
	for(int i=0; i<prod[symbol].size(); i++){
		for(int j=0; j<prod[symbol][i].size(); j++){
			if(isupper(prod[symbol][i][j])&&useful.find(prod[symbol][i][j])==useful.end()){
				useful.insert(prod[symbol][i][j]);
				useless(prod, useful, prod[symbol][i][j]);
			}
		}
	}

	return;
}

void findNullable(map<char, vector<string> > &prod, set<char> &nullable, bool verify){
	bool repeat = false;
	for(auto it = prod.begin(); it!=prod.end(); it++){
		if(nullable.find(it->first)!=nullable.end())
			break;

		for(int i=0; i<it->second.size(); i++){
			if(it->second[i][0]=='n'){
				nullable.insert(it->first);
				repeat = true;
				continue;
			}
			//check if all symbols in nullable
			bool nullble = true;
			for(int j=0; j<it->second[i].size(); j++){
				if(nullable.find(it->second[i][j])==nullable.end()){
					nullble = false;
					break;
				}
			}
			if(nullble){
				nullable.insert(it->first);
				repeat = true;
			}
		}
	}

	if(verify&&!repeat)
		return;
	else if(repeat)
		findNullable(prod, nullable, false);
	else
		findNullable(prod, nullable, true);

}

void addProd(map<char, vector<string> > &prod, set<char> &nullable){
	for(auto it = prod.begin(); it!=prod.end(); it++){
		for(int i=0; i<it->second.size(); i++){
			for(int j=0; j<it->second[i].size(); j++){
				if(nullable.find(it->second[i][j])!=nullable.end()){
					string tmp = it->second[i];
					tmp.erase(tmp.begin() + j);
					it->second.push_back(tmp);
				}
			}
			//remove if null
			if(it->second[i][0]=='n')
				it->second.erase(it->second.begin() + i);
		}

	}

	if(nullable.find(s)!=nullable.end())
		prod[s].push_back("n");

	return;
}

void unitRemove(map<char, vector<string> > &prod){
	for(auto it = prod.begin(); it!=prod.end(); it++){
		for(int i=0; i<it->second.size(); i++){
			if(it->second[i].size()==1&&isupper(it->second[i][0])){
				for(int j=0; j<prod[it->second[i][0]].size(); j++){
					it->second.push_back(prod[it->second[i][0]][j]);
				}

				it->second.erase(it->second.begin() + i);
			}
		}
	}
}

void print(map<char, vector<string> > &prod){
	for(auto it = prod.begin(); it!=prod.end(); it++){
		cout<<it->first<<" --> ";
		for(int i=0; i<it->second.size(); i++)
			cout<<it->second[i]<<" | ";
		cout<<endl;
	}
	cout<<endl;
	return;
}


int main(){
	map<char, vector<string> > prod;
	int n; char tmpc; string tmps;
	cout<<"No. of productions: "; cin>>n;
	cout<<"Start symbol: "; cin>>s;

	//Input
	for(int i=0; i<n; i++){
		cin>>tmpc;
		cin>>tmps;
		if(prod.find(tmpc)!=prod.end())
			prod[tmpc].push_back(tmps);
		else{
			vector<string> tmpv;
			tmpv.push_back(tmps);
			prod[tmpc] = tmpv;
		}
	}
	cout<<"Initially:\n\n";
	print(prod);
	//find useful
	set<char> useful;
	useful.insert(s);
	useless(prod, useful, s);
	//remove useless
	for(auto it = prod.begin(); it!=prod.end(); ){
		if(useful.find(it->first)==useful.end()){
			//remove
			auto tmp_it = it;
			tmp_it++;
			prod.erase(it);
			it = tmp_it;
		}
		else
			it++;
	}
	cout<<"After removing useless:\n\n";
	print(prod);

	set<char> nullable;
	findNullable(prod, nullable, false);
	
	cout<<"Nullable: ";
	for(auto it = nullable.begin(); it!=nullable.end(); it++)
		cout<<*it<<", ";
	cout<<"\n\n";

	addProd(prod, nullable);
	cout<<"After removing null productions:\n\n";
	print(prod);
	cout<<"\n\n";

	unitRemove(prod);
	unitRemove(prod);
	cout<<"After removing unit productions:\n\n";
	print(prod);



	return 0;

}