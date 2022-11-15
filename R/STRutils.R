# java -jar -Xmx10g -XX:ParallelGCThreads=1 $PICARDPATH MarkDuplicates \
# INPUT=output.sort.bam \
# OUTPUT=output.dedup.bam  \
# METRICS_FILE=output.dedup.bam.metrics.txt \
# VALIDATION_STRINGENCY=SILENT \
# MAX_FILE_HANDLES=1000 \
# CREATE_INDEX=true

soft <- "/media/respaldo4t/Picard/picard.jar"
system2(command = "java", args = c("-jar -Xmx10g -XX:ParallelGCThreads=1",soft,
                                   "MarkDuplicates"))

RunPicard <- function(bamFile){
  output.dedup.bam <- stringr::str_replace_all(bamFile, ".bam|.BAM","_dedup.bam")
  soft <- "/media/respaldo4t/Picard/picard.jar"
  system2(command = "java", args = c("-jar -Xmx10g -XX:ParallelGCThreads=1",soft,
                                     "MarkDuplicates",
                                     paste0("INPUT=",bamFile),
                                     paste0("OUTPUT=",output.dedup.bam),
                                     paste0("METRICS_FILE=",paste0(output.dedup.bam,".metrix.txt")),
                                     "VALIDATION_STRINGENCY=SILENT",
                                     "MAX_FILE_HANDLES=1000",
                                     "CREATE_INDEX=true")
  )
  if(file.exists(output.dedup.bam)){
    return(output.dedup.bam)
  }else
  {
    return(NULL)
  }
}

RunSTR <- function(bamFile){
  
  out <- system2(command="perl", args=c("/home/elmer/Bio-STR-exSTRa-master/bin/exSTRa_score.pl", 
                                 "/home/elmer/FLENI/hg19.fa", 
                                 "/home/elmer/Bio-STR-exSTRa-master/repeat_expansion_disorders_hg19.txt", 
                                 bamFile), stdout = TRUE)
  dat <- plyr::ldply(out, function(x){
    unlist(stringr::str_split(x,"\t"))
  })
  colnames(dat) <- dat[1,]
  dat <- dat[-1,]
  return(dat)
}

dat <- RunSTR("/media/respaldo4t/FLENI/Exomas/34708MODApy_realigned_reads_recal.bam")
View(dat)
system2(command="perl", args=c("/home/elmer/Bio-STR-exSTRa-master/bin/exSTRa_score.pl", 
                               "/home/elmer/FLENI/hg19.fa", 
                               "/home/elmer/Bio-STR-exSTRa-master/repeat_expansion_disorders_hg19.txt", 
                               "/media/respaldo4t/FLENI/Exomas/34708MODApy_realigned_reads_recal.bam"), stdout = "out.txt")


system.file("extdata", "HiSeqXTen_WGS_PCR_2.txt", package = "exSTRa")




dat <- plyr::ldply(out, function(x){
  unlist(stringr::str_split(x,"\t"))
})
colnames(dat) <- dat[1,]
dat <- dat[-1,]
View(dat)
