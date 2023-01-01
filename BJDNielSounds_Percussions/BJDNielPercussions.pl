#! /usr/bin/perl -w

my $dir = $ARGV[0];
die "directory does not exist" unless -e $dir;

my @wavfiles = <$dir/*.wav>;
$id = 0;

my $xmlhead = <<HEAD;
<drumkit_info>
    <name>BJDNielPercussions</name>
    <author>Yi Yunseok &lt;ironyunseok\@protonmail.com&gt;</author>
    <info>BJDNielPercussions is one of the BJDNielSounds collection created with BJD Doll **Niel**, a witch, session player and psychotherapist for GoldRock.</info>
    <license>CC-BY-SA 4.0</license>
    <image>==drumkitname==.jpg</image>
    <imageLicense>CC-BY-SA 4.0</imageLicense>
    <imageAuthor>Yi Yunseok &lt;ironyunseok\@protonmail.com&gt;</imageAuthor>
    <instrumentList>
HEAD

my $xmlbody = <<BODY;
        <instrument>
            <id>==id==</id>
            <name>==name==</name>
            <volume>1</volume>
            <isMuted>false</isMuted>
            <pan_L>1</pan_L>
            <pan_R>1</pan_R>
            <randomPitchFactor>0</randomPitchFactor>
            <gain>1</gain>
            <filterActive>false</filterActive>
            <filterCutoff>1</filterCutoff>
            <filterResonance>0</filterResonance>
            <Attack>0</Attack>
            <Decay>0</Decay>
            <Sustain>1</Sustain>
            <Release>1000</Release>
            <muteGroup>-1</muteGroup>
            <layer>
                <filename>==filename==</filename>
                <min>0</min>
                <max>1</max>
                <gain>1</gain>
                <pitch>0</pitch>
            </layer>
        </instrument>
BODY

my $xmlfoot = <<FOOT;
    </instrumentList>
</drumkit_info>
FOOT

open H2OFILE, "> $dir/drumkit.xml" or die $!;

my $drumkitname = $dir;
$drumkitname =~ s#^.*/##s;
my $head = $xmlhead;
  $head =~ s/==drumkitname==/$drumkitname/;
print H2OFILE $head;

foreach my $file (@wavfiles) {
  (warn 'filename must not contain quotes' && next) if $file =~ m/["']/;

  my $body = $xmlbody;
    $body =~ s/==id==/$id/;
    $file =~ s#^.*/##s;
    $body =~ s/==filename==/$file/;
    my $name = $file;
    $name =~ s/.wav$//;
    $body =~ s/==name==/$name/;

  (print H2OFILE $body) && $id++ unless $id > 31;
}

print H2OFILE $xmlfoot;

