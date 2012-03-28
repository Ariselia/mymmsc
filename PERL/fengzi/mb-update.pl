#!/usr/bin/perl -w
use strict;
use DBI;
use POSIX;
use JSON;
use Data::Dumper;
use LWP::UserAgent;
use File::Path;

#设定文件存储路径
my $dstPath = "/home/runtime/data/mb";
my $dataPath = $dstPath . '/file';
#设定MySQL数据库参数
my $db_name = 'feng';
my $db_host = '192.168.0.15';
my $db_user = 'devp';
my $db_pass = 'fxf.devp';

my $dsn = "DBI:mysql:database=$db_name;host=$db_host";
my $conn = DBI->connect($dsn, $db_user, $db_pass) or die "don't connect MySQL.";
$conn->do("SET NAMES 'utf8'");
my $i = 0;
for($i = 0; $i < 8; $i++) {
	my $query = "select id,content from media_code_${i}";
	my $sth = $conn->prepare($query);
	
	$sth->execute();
	while((my $id, my $content) = $sth->fetchrow_array){
		print "---------------------------------------------------------\n";
		print $content."\n";
		# 组织json文件的三级目录
		my $tmpPath = lc($id);
		my $dir1 = substr($tmpPath, 0, 2);
                my $dir2 = substr($tmpPath, 2, 2);
                my $dir3 = substr($tmpPath, 4, 2);
		my $subPath = "$dstPath/json/$dir1/$dir2/$dir3";
		mkpath($subPath, 1);
                my $filePath = $subPath . '/' . $id . '.json';
		open(FILE,">$filePath");
		syswrite(FILE, $content);
		close(FILE);
		my $json = new JSON;
		my $obj = $json->jsonToObj($content);
		print "The structure of obj: ".Dumper($obj);
		#获取富媒体总页数
		my %media = %$obj; 
		my $num = $media{totalCount};
		my $pageList = $media{pageList};
		foreach (@$pageList) {
			my %fmt = %$_;
			my $url = $fmt{mediaUrl};
			&download($url);
			$url = $fmt{tinypicUrl};
			&download($url);
			$url = $fmt{soundUrl};
			&download($url);
		}
		print "\n";
	}
}

print "\n";

sub download {
	my ($url) = @_;
	print "URL = " . $url . "\n";
 	#开始下载文件
        my $ua = LWP::UserAgent->new;
        $ua->timeout(30);
        $ua->env_proxy;
        my $resp = $ua->get($url);
        if($resp->is_success) {
        	my $mfile = $resp->filename;
                my $tmpPath = lc($mfile);
                # 三级目录
                my $dir1 = substr($tmpPath, 0, 2);
                my $dir2 = substr($tmpPath, 2, 2);
                my $dir3 = substr($tmpPath, 4, 2);
                my $subPath = "$dataPath/$dir1/$dir2/$dir3";
                mkpath($subPath,1);
                $mfile = $subPath . '/' . $mfile;
                print 'mfile = '. $mfile;
                open(FP, ">$mfile");
                syswrite(FP, $resp->content);
                close(FP);
	} else {
		 print 'Failed: ' . $resp->status_line;
	}
}
1;
