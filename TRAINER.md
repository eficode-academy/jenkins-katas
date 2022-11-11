# Instructions

The instructions for terraform-infra should be the
following:

```tfvars

cluster_initial_worker_count = 0 # Do not need kubernetes for the Jenkins training.
instance_count               = 3 # Adjust as needed n +2  where n=number of students.
instance_volume_size = 50  # Disk space on the instances.
user_instance_type = "t3a.large" # Adjust as needed

hosted_zone = "eficode.academy" # No need to change

code_server_enabled          = false # you do not need the code_server on the instances, since they can use their own machine running the exercise.
code_server_password         = "devops-is-cool"                 # Adjust as needed(Student instances)
code_server_password_bastion = "training-is-my-favourite-thing" # Adjust as needed(Trainer instance)

extra_bootstrap_cmds = "sudo -u ubuntu bash -c 'cd /home/ubuntu && git clone https://github.com/eficode-academy/jenkins-katas.git && ./jenkins-katas/setup/insertip.sh && docker-compose -f jenkins-katas/setup/docker-compose.yml up -d && ./jenkins-katas/setup/setup_swarm_on_host.sh'"

```

## changing the password

If you change the password in
`setup/secret/admin.txt` then please also reflect
it in `setup/docker-compose.yml` in order for the
swarm agent to be able to log in.
