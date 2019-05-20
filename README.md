# Docker version of [SnpEff](http://snpeff.sourceforge.net/)

## bundled with the GRCh37.75 (latest supported hg19) version

Docker file to build a bundle of latest snpEff VCF annotator with GRCh37 v75.
Indicative usage:

```
docker run -ti --rm \
    -v /my/full/local/vcf/path:/path/in/container \
    hybridstat/snpeff:4.3t \
    ann -v -t -noLog -noStats GRCh37.75 /path/in/container/my.vcf
```
