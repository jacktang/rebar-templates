# Basic development workflow

### Creating an initial framework of your future service:

    $ mkdir {service_name}
    $ cd {service_name}
    $ rebar create template=service name={service_name} description="Describe your service here."
    $ ./run.me.first.sh

See also [README.md](README.md).

### Cloning and running a fresh repo:

    $ git clone {url-to-the-repo}
    $ cd {service_name}
    $ make get-deps
    $ make run

### Changing code

    $ make run
    $ vim deps/{your_app}/src/{your_module}.erl

All changed modules will be automatically compiled and loaded
into Erlang VM using [sync](https://github.com/rustyio/sync).
Note that before changing the code for real in deps directory,
you should checkout a branch:

    $ cd deps/{your_app}
    $ git checkout master

It is needed because sometimes rebar leaves the deps repositories
in detached state ("Not currently at any branch").

### Creating appup files

    $ cd deps/{your_app}
    $ vim src/*.erl # meening you change your code in some way
    $ OLD_REV=`git rev-parse HEAD` # meening your just now the current rev
    $ git commit
    $ genappup $OLD_REV

or

    $ cd deps/{your_app}
    $ git co -b {your-branch}
    $ vim src/*.erl # meening you change your code in some way
    $ git commit
    $ genappup master

After `genappup` is run there will be a new file src/{your_app}.appup.src.
You should revise it, change manually if needed and commit.
At compile time, this file will be automatically copied to ebin/{your_app}.app
(Erlang/OTP releases require the appup file to be there).

Sometimes you will need the appup file for a third-party application.
If the owners do not use Erlang/OTP releases, most likely there
will not be an appup file in the repo.
In this case, you can still run `genappup` against the foreign repo and move
the generated {foreign_app}.appup.src file to your root project src directory.
Your root src dir can look like this:

    ebin/
    deps/
    src/
        {foreign_app1}.appup.src
        {foreign_app2}.appup.src
    priv/

Those files, at compile time, will be place to corresponding applications ebin directories.

See also
[genappup](https://github.com/EchoTeam/genappup) and
[Appup Cookbook](http://www.erlang.org/doc/design_principles/appup_cookbook.html).

### Adding a new dependency

    $ cd {project_root}
    $ vim rebar.config # meening you add a new app record to deps section
    $ make update-lock apps={new_app_name}
    $ git commit rebar.config rebar.config.lock

### Cheking how target system build works:

    $ git commit
    $ make target

### Cheking how upgrade build works:

    $ OLD_REV=`git rev-parse HEAD`
    $ git commit
    $ make upgrade-from=$OLD_REV



### See also:
[Makefile targets](service_MAKE.md)