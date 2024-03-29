#!/usr/bin/env python
#
#   main : launch commands
#

# default imports
from argparse import ArgumentParser as argparser
from getpass import getuser
from sys import exit

from keypin import commands


def makesubcommand(subparsers, name) :
    return subparsers.add_parser(name).set_defaults(
        func = getattr(commands, name))

# Main Program :
def main():
    try :
        # argument parser :
        parser = argparser()
        subparsers = parser.add_subparsers(title='commands', required=True)
        makesubcommand(subparsers, 'create') # on client or server
        makesubcommand(subparsers, 'plant') # on server
        makesubcommand(subparsers, 'connect') # can be done on client
        parser.add_argument('hostname', help='the target host')
        parser.add_argument('-u' , '--user', dest= 'user', help='user to use', default=getuser())
        # parse / execute
        args = parser.parse_args()
        args.func(args.hostname, args.user)

    except KeyboardInterrupt :
        print("[red]user interrupted the process, exiting[/red]")
        exit(1)
    except PermissionError :
        print("[red]cannot write ssh key, permission denied (try again with sudo)[/red]")
        exit(1)
    except Exception as E :
        exit(1)
    else:
        print(f"[green][bold]KeyPin[/bold] done[/green]")
        exit(0)

if __name__ == '__main__':
    main()
