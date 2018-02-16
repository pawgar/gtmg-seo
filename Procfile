web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=10 QUEUES=* rake resque:work
