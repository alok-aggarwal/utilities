FROM ubuntu:20.04
RUN apt-get update
COPY ./run_execve_in_a_loop.sh /
COPY ./do_nothing /bin
RUN chmod +x /bin/do_nothing
RUN chmod +x /run_execve_in_a_loop.sh
CMD ["/run_execve_in_a_loop.sh"]
