#!/usr/bin/env ruby

# пробрасываем прот 22 openssh-server на удаленный серве.
# после проброса с удаленного сервера можно зайти по ssh на любой компьютер,
# на котором был выполенн этот код.
# например: ssh -p 3000 username@localhost
system "ssh -R 3000:localhost:22 support@192.168.4.39"