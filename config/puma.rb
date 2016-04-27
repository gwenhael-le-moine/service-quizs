threads 1,8
workers 3
preload_app!
daemonize
bind 'tcp://0.0.0.0:9240'
environment 'development'
directory '/home/erasme/laclasse-quiz/'
pidfile '/var/run/laclasse-quiz/puma.pid'
state_path '/var/run/laclasse-quiz/puma.state'
activate_control_app 'tcp://0.0.0.0:9241', { auth_token: 'aazzaazzaa' }
stdout_redirect '/var/log/laclasse-quiz/puma.log', '/var/log/laclasse-quiz/puma_error.log', true
tag 'puma-laclasse-quiz'

