//
//  Graph.h
//  bjsubway
//
//  Created by apple on 14/12/10.
//  Copyright (c) 2014年 bangtech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
/* 邻接表表示的图结构 */
#include <stdio.h>
#include<stdlib.h>
//#define DEBUG
#define MAXVEX 300         //最大顶点数
//#define MAXVEX  100     //最大顶点数
//typedef int Boolean;            //Boolean 是布尔类型，其值是TRUE 或FALSE
bool visited[MAXVEX];        //访问标志数组
#define TRUE 1
#define FALSE 0
#define IS_NORMSCREEN ( fabs( ( double )([ [ UIScreen mainScreen ] bounds ].size.width>[ [ UIScreen mainScreen ] bounds ].size.height?[ [ UIScreen mainScreen ] bounds ].size.width:[ [ UIScreen mainScreen ] bounds ].size.height) - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPAD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPad" ] )
#define IS_IPHONE_4 ( IS_IPHONE && IS_NORMSCREEN )

//typedef int VertexDataType;        //顶点类型应由用户定义
typedef struct EdgeType
{
    int count;
    float distance;
} EdgeType;           //边上的权值类型应由用户定义

typedef struct VertexType        //边表结点
{
    int vexid;            //uid
    char staname[20];     //station name
    //int lenname;
    char poidesc[1000];     //poi description
    CGPoint pos;         //邻接点域，存储该顶点对应的下标
    EdgeType weight;        //用于存储权值，对于非网图可以不需要
}VertexType;

typedef struct EdgeNode        //边表结点
{
    int adjvex;         //邻接点域，存储该顶点对应的下标
    EdgeType weigth;        //用于计算公里数
    struct EdgeNode *next;      //链域，指向下一个邻接点
}EdgeNode;

typedef struct VertexNode       //顶点表结构
{
    VertexType data;        //顶点域，存储顶点信息
    EdgeType weigth;        //用于计算最短路径的权值
    EdgeNode *firstedge;        //边表头指针
    struct VertexNode *path;    //trip
}VertexNode, AdjList[MAXVEX];

typedef struct
{
    AdjList adjList;
    bool visited[MAXVEX];        //访问标志数组
    int numVertexes;
    int numEdges;  //图中当前顶点数和边数
}GraphList;

typedef struct{
    int count;
    float weight;
    short route[MAXVEX];
}Distance;
typedef struct NearBy{
    int vexid;            //uid
    char staname[20];     //station name
    CGPoint pos;         //邻接点域，存储该顶点对应的下标
}NearBy;
@interface Graph : NSObject
    @property(nonatomic, strong) NSValue* graph;
    @property(nonatomic, strong) NSNumber* numVertexes;
    @property(nonatomic, strong) NSNumber* numEdges;  //图中当前顶点数和边数
    @property(nonatomic, strong) NSArray* dataware ;
    @property(nonatomic, strong) NSArray* poiware ;
    @property(nonatomic, strong) NSArray* busware ;
- (instancetype) initWithGraphList:    (GraphList*) g;
- (NSArray*) Nearby:(CGPoint) touchPoint;
- (NSString*) NameByIndex:(int) index;
- (bool) isTransfer:(int) index;
- (int) Locate:(CGPoint) touchPoint;
-(void) createGraph:(GraphList *)g;
- (void) printGraph;
-(void) DFS:(GraphList*)g :(int) i;
-(void)DFSTraverse:(GraphList*) g;
-(void) BFSTraverse;
-(Distance) Path:(GraphList *)g :(int)start :(int) end;

@end


//int Locate(GraphList *g, int vexid)
//{
//    int i;
//    for(i = 0; i < MAXVEX; i++)
//    {
//        if(vexid == g->adjList[i].data.vexid)
//        {
//            break;
//        }
//    }
//    if(i >= MAXVEX)
//    {
//        fprintf(stderr,"there is no vertex.\n");
//        return -1;
//    }
//    return i;
//}


////建立图的邻接表结构
//void CreateGraph(GraphList *g)
//{
//    int i, j, k;
//    EdgeNode *e;
//    EdgeNode *f;
//    printf("输入顶点数和边数:\n");
//    scanf("%d,%d", &g->numVertexes, &g->numEdges);
//
//#ifdef DEBUG
//    printf("%d,%d\n", g->numVertexes, g->numEdges);
//#endif
//
//    for(i = 0; i < g->numVertexes; i++)
//    {
//        printf("请输入顶点%d:\n", i);
//        g->adjList[i].data = getchar();          //输入顶点信息
//        g->adjList[i].firstedge = NULL;          //将边表置为空表
//        while(g->adjList[i].data == '\n')
//        {
//            g->adjList[i].data = getchar();
//        }
//    }
//    //建立边表
//    for(k = 0; k < g->numEdges; k++)
//    {
//        printf("输入边(vi,vj)上的顶点序号:\n");
//        char p, q;
//        p = getchar();
//        while(p == '\n')
//        {
//            p = getchar();
//        }
//        q = getchar();
//        while(q == '\n')
//        {
//            q = getchar();
//        }
//        int m, n;
//        m = Locate(g, p);
//        n = Locate(g, q);
//        if(m == -1 || n == -1)
//        {
//            return;
//        }
//#ifdef DEBUG
//        printf("p = %c\n", p);
//        printf("q = %c\n", q);
//        printf("m = %d\n", m);
//        printf("n = %d\n", n);
//#endif
//
//        //向内存申请空间，生成边表结点
//        e = (EdgeNode *)malloc(sizeof(EdgeNode));
//        if(e == NULL)
//        {
//            fprintf(stderr, "malloc() error.\n");
//            return;
//        }
//        //邻接序号为j
//        e->adjvex = n;
//        //将e指针指向当前顶点指向的结构
//        e->next = g->adjList[m].firstedge;
//        //将当前顶点的指针指向e
//        g->adjList[m].firstedge = e;
//
//        f = (EdgeNode *)malloc(sizeof(EdgeNode));
//        if(f == NULL)
//        {
//            fprintf(stderr, "malloc() error.\n");
//            return;
//        }
//        f->adjvex = m;
//        f->next = g->adjList[n].firstedge;
//        g->adjList[n].firstedge = f;
//    }
//}


//void printGraph(GraphList *g)
//{
//    int i = 0;
//#ifdef DEBUG
//    printf("printGraph() start.\n");
//#endif
//    
//    while(g->adjList[i].firstedge != NULL && i < MAXVEX)
//    {
//        printf("顶点:%c  ", g->adjList[i].data.vexid);
//        EdgeNode *e = NULL;
//        e = g->adjList[i].firstedge;
//        while(e != NULL)
//        {
//            printf("%d  ", e->adjvex);
//            e = e->next;
//        }
//        i++;
//        printf("\n");
//    }
//}