package main

import "fmt"
import "os/exec"
import "bytes"
import "github.com/pkg/errors"
import "github.com/docker/docker/errdefs"

func main() {
	//	fmt.Println("vim-go")
	output, err := exec.Command("ps", "-ef").Output()
	if err != nil {
		if ee, ok := err.(*exec.ExitError); ok {
			// first line of stderr shows why ps failed
			line := bytes.SplitN(ee.Stderr, []byte{'\n'}, 2)
			if len(line) > 0 && len(line[0]) > 0 {
				err = errors.New(string(line[0]))
			}
		}
		err = errdefs.System(errors.Wrap(err, "ps"))
	}
	fmt.Println(string(output), err)

}
