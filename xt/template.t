#!perl -w
use strict;
use Test::More;

use Dist::Maker::Scatter;
use Dist::Maker::Util qw(available_templates);
use File::Path qw(rmtree);
use Cwd qw(getcwd);

my @templates = @ARGV;
@templates = available_templates() unless @templates;

if($ENV{PERL5LIB}) {
    $ENV{PERL5LIB} .= ":" . join ":", @INC;
}
else {
    $ENV{PERL5LIB} = join ":", @INC;
}

foreach my $template(@templates) {
    note "Template: $template";

    my $dms = Dist::Maker::Scatter->new(
        dist      => "Foo-$template",
        template  => $template,
        cache_dir => '.test_cache',
    );

    my $oldcwd = getcwd();
    my $d      = ".test/make_test/" . $dms->dist;

    rmtree $d, { verbose => 0 };
    $dms->scatter($d);
    chdir $d or die "Failed to chdir($d): $!";

    cmd_ok($^X, 'Makefile.PL');
    cmd_ok("make");
    cmd_ok("make", "manifest"); # required for podsynopsis.t
    cmd_ok("make", "test");
    cmd_ok("make", "realclean");

    chdir $oldcwd;
}

sub cmd_ok {
    is system(@_), 0, "@_"
        or die "Failed to @_\n";
}

done_testing;
