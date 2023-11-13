import git 
import os

#clone's github repository
# repo_url = "https://github.com/LamAnnieV/group_deployment_8.git"
# local_path = "/home/ubuntu/group_deployment_8"
# repo = git.Repo.clone_from(repo_url, local_path) 
# print(f'Repository Cloned at location: {local_path}') 

#locates the local repository directory
local_path = "/home/ubuntu/group_deployment_8"
#repository url to push it towards
repository_url = "https://github.com/LamAnnieV/group_deployment_8.git"

if not os.path.exists(local_path):
    # If it doesn't exist, clone the repository from the URL
    repo = git.Repo.clone_from(repository_url, local_path)
else:
    # If it already exists, open the existing repository
    repo = git.Repo(local_path) 

origin = repo.remote(name='origin')
origin.set_url(repository_url) 
  
existing_branch = repo.heads['main'] 
existing_branch.checkout() 

# repo.git.add(all=True)  
repo.index.add("README.md")
repo.index.commit('Initial commit on new branch') 
print('Commited successfully') 
origin.push() 
print('Pushed changes to origin')
