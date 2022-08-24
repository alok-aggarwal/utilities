#include <errno.h>
#include <fcntl.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

// From main() create a unix socket pair and call fork()
//
// Parent flow:
// 1. Wait on unix socket to get a dirfd
// 2. On getting the dirfd create a file relative to the dirfd received from
// child
//
// Child flow:
// 1. Setns to host's mount ns
// 2. open a directory and get dirfd
// 3. send the dirfd on the unix socket

static void post_fd(int socket, int fd) // send fd by socket
{
  struct msghdr msg = {0};
  char buf[CMSG_SPACE(sizeof(fd))];
  memset(buf, '\0', sizeof(buf));

  struct iovec io = {.iov_base = (void *)"ABC", .iov_len = 3};

  msg.msg_iov = &io;
  msg.msg_iovlen = 1;
  msg.msg_control = buf;
  msg.msg_controllen = sizeof(buf);

  struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg);
  cmsg->cmsg_level = SOL_SOCKET;
  cmsg->cmsg_type = SCM_RIGHTS;
  cmsg->cmsg_len = CMSG_LEN(sizeof(fd));

  *((int *)CMSG_DATA(cmsg)) = fd;

  msg.msg_controllen = CMSG_SPACE(sizeof(fd));

  if (sendmsg(socket, &msg, 0) < 0)
    printf("pid = %d: Failed to send message\n", getpid());
}

static int get_fd(int socket) // receive fd from socket
{
  struct msghdr msg = {0};

  char m_buffer[256];
  struct iovec io = {.iov_base = m_buffer, .iov_len = sizeof(m_buffer)};
  msg.msg_iov = &io;
  msg.msg_iovlen = 1;

  char c_buffer[256];
  msg.msg_control = c_buffer;
  msg.msg_controllen = sizeof(c_buffer);

  struct timeval tv;
  tv.tv_sec = 5;
  tv.tv_usec = 0;
  setsockopt(socket, SOL_SOCKET, SO_RCVTIMEO, (const char *)&tv, sizeof tv);

  if (recvmsg(socket, &msg, 0) < 0) {
    printf("pid = %d: Failed to receive message\n", getpid());
    return -1;
  }

  struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg);

  unsigned char *data = CMSG_DATA(cmsg);

  printf("pid = %d: About to extract fd\n", getpid());
  int fd = *((int *)data);
  printf("pid = %d: Extracted fd %d\n", getpid(), fd);

  return fd;
}

int main() {

  int sv[2];
  if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sv) != 0)
    printf("pid = %d: Failed to create Unix-domain socket pair\n", getpid());

  int pid = fork();
  if (pid > 0) // in parent
  {
    printf("pid = %d: Parent at work\n", getpid());
    close(sv[1]);
    int sock = sv[0];

    struct timespec ts;

    ts.tv_nsec = 500000000;
    ts.tv_sec = 0;

    nanosleep(&ts, 0);

    int dirfd = get_fd(sock);

    if (dirfd < 0) {
      printf("pid = %d: couldn't get fd from child, exiting!\n", getpid());
      return 1;
    }
    printf("pid = %d: Read %d!\n", getpid(), dirfd);

    int fd = openat(dirfd, "tmpfile", O_CREAT, S_IXUSR);
    if (fd > 0) {
      printf("pid = %d: creating file in host filesystem successful\n",
             getpid());
    } else {
      perror("creating file in host filesystem not successful");
    }

    //check upper_dir exists
    //upperdir=/var/lib/docker/overlay2/02236354fcbd311797e4e5b6a64871ca45cc090b7fd5d26b799df9aa1cba6277/diff
    int upperdir_fd = openat(dirfd, "var/lib/docker/overlay2/02236354fcbd311797e4e5b6a64871ca45cc090b7fd5d26b799df9aa1cba6277/diff", O_RDONLY);
    if (upperdir_fd > 0) {
      printf("pid = %d: upperdir exists!\n",
             getpid());
    } else {
      perror("upperdir does not exist");
    }


    //check regular file presence
    int regular_file_fd = openat(dirfd, "var/lib/docker/overlay2/02236354fcbd311797e4e5b6a64871ca45cc090b7fd5d26b799df9aa1cba6277/diff/usr/bin/dpkg", O_RDONLY);
    if (regular_file_fd > 0) {
      printf("pid = %d: regular_file_fd exits!\n",
             getpid());
    } else {
      perror("regular_file_fd does not exist");
    }

    //check drifted file presence
    int drifted_file_fd = openat(upperdir_fd, "usr/bin/drifted_dpkg", O_RDONLY);
    if (drifted_file_fd > 0) {
      printf("pid = %d: drifted_file_fd exists!\n",
             getpid());
    } else {
      perror("drifted_file_fd does not exist");
    }
    
    //allow time for child to exit
    ts.tv_nsec = 500000000;
    ts.tv_sec = 1;

    nanosleep(&ts, 0);

    close(fd);
    close(dirfd);

    printf("pid = %d: Parent exits\n", getpid());
  } else // in child
  {
    printf("pid = %d: Child at play\n", getpid());
    close(sv[0]);
    int sock = sv[1];

    int err = 0, dirfd, fd, host_mnt_fd;

    host_mnt_fd = open("/proc/1/ns/mnt", O_RDONLY);
    printf("pid = %d: host_mnt_fd = %d\n", getpid(), host_mnt_fd);

    err = setns(host_mnt_fd, CLONE_NEWNS);
    if (err < 0) {
      perror("\nError: switching mount ns to host failed");
    } else {
      printf("pid = %d: setns to host successful\n", getpid());
    }

    dirfd = open("/", O_DIRECTORY);
    if (dirfd < 0) {
      printf("pid = %d: Failed to open directory %s \n", getpid(),
             "/");
    }

    post_fd(sock, dirfd);

    struct timespec ts;

    ts.tv_nsec = 500000000;
    ts.tv_sec = 1;

    nanosleep(&ts, 0);

    printf("pid = %d: Child Done!\n", getpid());
    close(dirfd);
  }
  return 0;
}
