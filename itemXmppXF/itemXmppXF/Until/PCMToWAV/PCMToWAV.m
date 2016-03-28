//
//  PCMToWAV.m
//  PCMPlay
//
//  Created by 钱老师 on 14-5-8.
//  Copyright (c) 2014年 钱老师. All rights reserved.
//

#import "PCMToWAV.h"

static PCMToWAV *g_pcm = nil;

@implementation PCMToWAV

+ (PCMToWAV*)sharePCM
{
    if (!g_pcm){
        g_pcm = [[PCMToWAV alloc] init];
    }
    
    return g_pcm;
}

/**
 @功能：给pcm添加wav头并转成wav音频文件
 @参数：文件全路径数组(wav的全路径 pcm的全路径)
 @返回值：无
 */
- (void)pcmToWav:(NSArray*)array
{
    //wav头的结构如下所示：
    typedef   struct
    {
        char     fccID[4];
        unsigned   long      dwSize;
        char     fccType[4];
    }HEADER; //RIFF WAVE Chunk
    typedef   struct
    {
        char    fccID[4];
        unsigned   long  dwSize;
        unsigned   short    wFormatTag;
        unsigned   short    wChannels;
        unsigned   long     dwSamplesPerSec;
        unsigned   long     dwAvgBytesPerSec;
        unsigned   short    wBlockAlign;
        unsigned   short    uiBitsPerSample;
    }FMT; //Format Chunk
    
    typedef   struct
    {
        char    fccID[4];
        unsigned   long     dwSize;
    }DATA; //Data Chunk
    //以上是wav头文件
    
    //以下是为了建立.wav头而准备的变量
    HEADER  pcmHEADER;
    FMT  pcmFMT;
    DATA pcmDATA;
    //以上是为了建立.wav头而准备的变量
    
    
    BOOL exist = NO;
    NSString *wavPath = [array objectAtIndex:0];
    NSString *pcmPath = [array objectAtIndex:1];
    if (![[NSFileManager defaultManager] fileExistsAtPath:wavPath isDirectory:&exist])
    {
        [[NSFileManager defaultManager] createFileAtPath:wavPath contents:nil attributes:nil];
    }
    
    unsigned   short   m_pcmData;                       //读入.pcm和写入文件.wav数据变量
    FILE   *fp,*fpCpy;
    
    if((fp=fopen([pcmPath UTF8String], "rb"))   ==   NULL)  //读取文件
    {
        printf( "打开pcm文件出错 \n");
    }
    
    if((fpCpy=fopen([wavPath UTF8String], "wb+"))   ==   NULL)  //为转换建立一个新文件
    {
        printf( "创建wav文件出错\n ");
    }
    
    //以下是创建wav头的HEADER;但.dwsize未定，因为不知道Data的长度。
    strcpy(pcmHEADER.fccID, "RIFF");
    strcpy(pcmHEADER.fccType, "WAVE");
    fseek(fpCpy,sizeof(HEADER),1); //跳过HEADER的长度，以便下面继续写入wav文件的数据;
    //以上是创建wav头的HEADER;
    
    if(ferror(fpCpy))
    {
        printf( "error!\n ");
    }
    
    //以下是创建wav头的FMT;
    strcpy(pcmFMT.fccID, "fmt   ");
    pcmFMT.dwSize=16;
    pcmFMT.wFormatTag=1;
    pcmFMT.wChannels=1;
    pcmFMT.dwSamplesPerSec=16000;
    pcmFMT.dwAvgBytesPerSec=pcmFMT.dwSamplesPerSec*sizeof(m_pcmData);
    pcmFMT.wBlockAlign=2;
    pcmFMT.uiBitsPerSample=16;
    //以上是创建wav头的FMT;
    
    
    fwrite(&pcmFMT,sizeof(FMT),1,fpCpy); //将FMT写入.wav文件;
    //以下是创建wav头的DATA;   但由于DATA.dwsize未知所以不能写入.wav文件
    strcpy(pcmDATA.fccID, "data ");
    //以上是创建wav头的DATA;
    
    NSData *data = [NSData dataWithContentsOfFile:pcmPath];
    pcmDATA.dwSize=data.length; //给pcmDATA.dwsize   0以便于下面给它赋值
    fseek(fpCpy,sizeof(DATA),1); //跳过DATA的长度，以便以后再写入wav头的DATA;
    fread(&m_pcmData,sizeof(unsigned   short),1,fp); //从.pcm中读入数据
    
    while(!feof(fp)) //在.pcm文件结束前将他的数据转化并赋给.wav;
    {
        fwrite(&m_pcmData,sizeof(unsigned   short),1,fpCpy); //将数据写入.wav文件;
        fread(&m_pcmData,sizeof(unsigned   short),1,fp); //从.pcm中读入数据
    }
    
    fclose(fp); //关闭文件
    pcmHEADER.dwSize=44+pcmDATA.dwSize;   //根据pcmDATA.dwsize得出pcmHEADER.dwsize的值
    rewind(fpCpy); //将fpCpy变为.wav的头，以便于写入HEADER和DATA;
    fwrite(&pcmHEADER,sizeof(HEADER),1,fpCpy); //写入HEADER
    fseek(fpCpy,sizeof(FMT),1); //跳过FMT,因为FMT已经写入
    fwrite(&pcmDATA,sizeof(DATA),1,fpCpy);   //写入DATA;
    fclose(fpCpy);   //关闭文件
}

@end
