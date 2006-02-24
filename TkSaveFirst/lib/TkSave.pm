#!/usr/bin/perl
package TkSave;
require Exporter;
use Tk; 
use Cwd;

our @ISA = "Exporter";
our @EXPORT = qw (saveit $w $cwd $as) ;
our @EXPORT_OK = qw (saveit $w $cwd $as);

###
$as = 0; 
$cwd = getcwd; 

sub saveit
	{	
	@contents_file = @_;
	$file = $contents_file[0];
	@contents = @contents_file[1 .. @contents_file];
	

	if ($as)
		{ 
		$str = "Save '$file' as..."; 
		} 
	else
		{ 
		$str = "Save '$file'" ;
		} 

	$w = new MainWindow(-title=>"Save '$file'");
	$dirlist = $w -> DirTree (-width=>55) -> pack(-fill=>'x') ;
	$dirlabel = $w -> Label (-text=>"Select a directory for the new directory to be created under and enter name for the new directory:") -> pack (-fill=>'x' );
	$dirent = $w -> Entry () -> pack (-fill=>'x') ;
	$newdir = $w -> Button (-command=>sub { newdir(); } , -activebackground=>'blue', -text=>'NEW DIR')-> pack (-fill=>'x');
	$botlabel = $w -> Label (-text=>"Select a directory where you want to save the file and type the file name:") -> pack (-fill=>'x');
	$filename = $w -> Entry () -> pack (-fill=>'x');
	$filename -> insert (0, $file) if ! $as ; 
	$finalsavebutt = $w -> Button (-command=>\&savefinal, -text=>'SAVE THE FILE', -activebackground=>'blue')  -> pack (-fill=>'both');
	if ($file =~ /^$|^\s*$/) 
		{ 
		my $d = $w -> Dialog (-text=>"Your file name was blank. Try again" ,-title=>"Error"); 
		$d->Show(); 	
		$w -> destroy();
		} 	
	MainLoop(); 
	
	} 
sub savefinal
	{ 
	$die1 = $w -> Dialog (-text=>'An error occured while saving. Remember to select only one directory and to include a file name.' ,-title=>"Error");
	$die2 = $w -> Dialog (-text=>'File already exists. Overwrite it?', -buttons=>['Yes', 'No'], -title=>"Overwrite file?");
	if (! $dirlist -> info ('selection') or $dirlist-> info ('selection') > 1 or $filename-> get() =~ /^$|^\s*$/)
		{
		$die1 -> Show() ; 
		return;
		} 
	if (-e join ('', $dirlist->info('selection')) . '/' . $filename-> get() )
		{
		$tmp=$die2->Show();
		if ($tmp eq 'No')
			{
			return; 
			}
		}
	$finfile = join ('', $dirlist->info('selection')) . '/' . $filename-> get();
	open (A,">$finfile");
	print A @contents; 
	close (A);
	$w -> $destroy; 
	$w = ''; 
	return;
	
	} 
sub newdir
	{ 
	$g = $w -> Dialog (-text=>"No directory selected or directory name empty or directory already exists.", -title=>'Error');
	$a = $w -> Dialog (-text=>"Directory created successfully.", -title=>'Success');
	if ( ! $dirlist -> info ('selection') or $dirlist -> info ('selection') > 1 or $dirent -> get() =~ /^$|^\s*$/)
		{ 
		
		$g->Show();
		return;  
		} 
	print (join ('', $dirlist -> info ('selection')) . $dirent -> get()); 
	$a -> Show and return 1 if mkdir (join ('', $dirlist -> info ('selection')) . '/' .$dirent -> get()); 
	$g->Show();	
	return 0;
	} 

1;
__END__

=head1 NAME

TkSave - Perl extension for blah blah blah

=head1 SYNOPSIS

  use TkSave;
  saveit ( $filename, @filecontents );
  # where $filename is the name of the file to save and @filecontents is the contents of that file. 
  # saveit opens a save dialog box and uses these parameters. If called without @filecontents, the file saved will simply be empty. 

=head1 DESCRIPTION

This module is very easy to use. It only has one funtion, saveit. It is a save file dialog box. It is described under SYNOPSIS. 

When you use the module, you also get access to the $w variable that equals the MainWindow object (Tk) so you can use it to control whether or not the save dialog box has more than one instance. You also get access to the $as variable. Set this to true and saveit will act as a save as dialog box. 

One more thing of note: When the save dialog box or save as dialog box is closed, $w is set to the null string. 

=head1 SEE ALSO

See also Tk! It rocks. 

check me out @ www.infusedlight.net

=head1 AUTHOR

Robin Bank, webmaster@infusedlight.net

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Robin Bank

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
