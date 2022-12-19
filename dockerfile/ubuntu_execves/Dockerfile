FROM ubuntu:20.04
RUN apt-get update
COPY ./run_system_procs_in_a_loop.sh /
RUN chmod +x /run_system_procs_in_a_loop.sh
CMD ["/run_system_procs_in_a_loop.sh"]
