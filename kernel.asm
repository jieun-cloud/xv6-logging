
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 2e 10 80       	mov    $0x80102ef0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 20 6d 10 	movl   $0x80106d20,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 40 41 00 00       	call   801041a0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 27 6d 10 	movl   $0x80106d27,0x4(%esp)
8010009b:	80 
8010009c:	e8 cf 3f 00 00       	call   80104070 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 25 42 00 00       	call   80104310 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 1a 42 00 00       	call   80104380 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 3f 3f 00 00       	call   801040b0 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 a2 1f 00 00       	call   80102120 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 2e 6d 10 80 	movl   $0x80106d2e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 9b 3f 00 00       	call   80104150 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 3f 6d 10 80 	movl   $0x80106d3f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 5a 3f 00 00       	call   80104150 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 0e 3f 00 00       	call   80104110 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 02 41 00 00       	call   80104310 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 2b 41 00 00       	jmp    80104380 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 46 6d 10 80 	movl   $0x80106d46,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 09 15 00 00       	call   80101790 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 7d 40 00 00       	call   80104310 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 23 34 00 00       	call   801036d0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 38 3a 00 00       	call   80103d00 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 6a 40 00 00       	call   80104380 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 92 13 00 00       	call   801016b0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 4c 40 00 00       	call   80104380 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 74 13 00 00       	call   801016b0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 e5 23 00 00       	call   80102760 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 4d 6d 10 80 	movl   $0x80106d4d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 97 76 10 80 	movl   $0x80107697,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 0c 3e 00 00       	call   801041c0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 61 6d 10 80 	movl   $0x80106d61,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 72 54 00 00       	call   80105880 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 c2 53 00 00       	call   80105880 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 b6 53 00 00       	call   80105880 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 aa 53 00 00       	call   80105880 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 6f 3f 00 00       	call   80104470 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 b2 3e 00 00       	call   801043d0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 65 6d 10 80 	movl   $0x80106d65,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 90 6d 10 80 	movzbl -0x7fef9270(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 89 11 00 00       	call   80101790 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 fd 3c 00 00       	call   80104310 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 45 3d 00 00       	call   80104380 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 6a 10 00 00       	call   801016b0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 88 3c 00 00       	call   80104380 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 78 6d 10 80       	mov    $0x80106d78,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 74 3b 00 00       	call   80104310 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 7f 6d 10 80 	movl   $0x80106d7f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 46 3b 00 00       	call   80104310 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 54 3b 00 00       	call   80104380 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 d9 35 00 00       	call   80103e90 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 44 36 00 00       	jmp    80103f70 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 88 6d 10 	movl   $0x80106d88,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 36 38 00 00       	call   801041a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100997:	e8 14 19 00 00       	call   801022b0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 1f 2d 00 00       	call   801036d0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 54 22 00 00       	call   80102c10 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 39 15 00 00       	call   80101f00 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 d7 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 65 0f 00 00       	call   80101960 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 08 0f 00 00       	call   80101910 <iunlockput>
    end_op();
80100a08:	e8 73 22 00 00       	call   80102c80 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 3f 60 00 00       	call   80106a70 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 cd 0e 00 00       	call   80101960 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 09 5e 00 00       	call   801068e0 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 08 5d 00 00       	call   80106820 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 c2 5e 00 00       	call   801069f0 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 d5 0d 00 00       	call   80101910 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 3b 21 00 00       	call   80102c80 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 6f 5d 00 00       	call   801068e0 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 67 5e 00 00       	call   801069f0 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100b93:	e8 e8 20 00 00       	call   80102c80 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 a1 6d 10 80 	movl   $0x80106da1,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 53 5f 00 00       	call   80106b20 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 59 01 00 00    	je     80100d33 <exec+0x393>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 ea 39 00 00       	call   801045f0 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 d9 39 00 00       	call   801045f0 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 4a 60 00 00       	call   80106c80 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 d7 5f 00 00       	call   80106c80 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 ba 38 00 00       	call   801045b0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 6c 59 00 00       	call   80106690 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 c4 5c 00 00       	call   801069f0 <freevm>
  return 0;
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d33:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d39:	31 d2                	xor    %edx,%edx
80100d3b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d41:	e9 18 ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d46:	66 90                	xchg   %ax,%ax
80100d48:	66 90                	xchg   %ax,%ax
80100d4a:	66 90                	xchg   %ax,%ax
80100d4c:	66 90                	xchg   %ax,%ax
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	c7 44 24 04 ad 6d 10 	movl   $0x80106dad,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 36 34 00 00       	call   801041a0 <initlock>
}
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d83:	e8 88 35 00 00       	call   80104310 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 cb 35 00 00       	call   80104380 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100db5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100db8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc7:	e8 b4 35 00 00       	call   80104380 <release>
  return 0;
}
80100dcc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dcf:	31 c0                	xor    %eax,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df1:	e8 1a 35 00 00       	call   80104310 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e0a:	e8 71 35 00 00       	call   80104380 <release>
  return f;
}
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e17:	c7 04 24 b4 6d 10 80 	movl   $0x80106db4,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e43:	e8 c8 34 00 00       	call   80104310 <acquire>
  if(f->ref < 1)
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
    release(&ftable.lock);
80100e5d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6b:	e9 10 35 00 00       	jmp    80104380 <release>
    return;
  }
  ff = *f;
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e8f:	e8 ec 34 00 00       	call   80104380 <release>

  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 a8 24 00 00       	call   80103360 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ec0:	e8 4b 1d 00 00       	call   80102c10 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 00 09 00 00       	call   801017d0 <iput>
    end_op();
  }
}
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ed7:	e9 a4 1d 00 00       	jmp    80102c80 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100edc:	c7 04 24 bc 6d 10 80 	movl   $0x80106dbc,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 a6 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 14 0a 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 69 08 00 00       	call   80101790 <iunlock>
    return 0;
  }
  return -1;
}
80100f27:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f2a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
    ilock(f->ip);
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 41 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 d7 09 00 00       	call   80101960 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 f3 07 00 00       	call   80101790 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb5:	e9 26 25 00 00       	jmp    801034e0 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fc7:	c7 04 24 c6 6d 10 80 	movl   $0x80106dc6,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 57 07 00 00       	call   80101790 <iunlock>
      end_op();
80101039:	e8 42 1c 00 00       	call   80102c80 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101049:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 06 00 00       	mov    $0x600,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101063:	e8 a8 1b 00 00       	call   80102c10 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 3d 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 ce 09 00 00       	call   80101a60 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 ec 06 00 00       	call   80101790 <iunlock>
      end_op();
801010a4:	e8 d7 1b 00 00       	call   80102c80 <end_op>

      if(r < 0)
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 0f 23 00 00       	jmp    801033f0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	c7 04 24 cf 6d 10 80 	movl   $0x80106dcf,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ed:	c7 04 24 d5 6d 10 80 	movl   $0x80106dd5,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	89 d7                	mov    %edx,%edi
80101106:	56                   	push   %esi
80101107:	53                   	push   %ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101108:	bb 01 00 00 00       	mov    $0x1,%ebx
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010110d:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101110:	c1 ea 0c             	shr    $0xc,%edx
80101113:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101119:	89 04 24             	mov    %eax,(%esp)
8010111c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101120:	e8 ab ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101125:	89 f9                	mov    %edi,%ecx
{
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
80101127:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
8010112d:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
8010112f:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101132:	c1 fa 03             	sar    $0x3,%edx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101135:	d3 e3                	shl    %cl,%ebx
bfree(int dev, uint b)
{
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101137:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
80101139:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010113e:	0f b6 c8             	movzbl %al,%ecx
80101141:	85 d9                	test   %ebx,%ecx
80101143:	74 20                	je     80101165 <bfree+0x65>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101145:	f7 d3                	not    %ebx
80101147:	21 c3                	and    %eax,%ebx
80101149:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
8010114d:	89 34 24             	mov    %esi,(%esp)
80101150:	e8 5b 1c 00 00       	call   80102db0 <log_write>
  brelse(bp);
80101155:	89 34 24             	mov    %esi,(%esp)
80101158:	e8 83 f0 ff ff       	call   801001e0 <brelse>
}
8010115d:	83 c4 1c             	add    $0x1c,%esp
80101160:	5b                   	pop    %ebx
80101161:	5e                   	pop    %esi
80101162:	5f                   	pop    %edi
80101163:	5d                   	pop    %ebp
80101164:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101165:	c7 04 24 df 6d 10 80 	movl   $0x80106ddf,(%esp)
8010116c:	e8 ef f1 ff ff       	call   80100360 <panic>
80101171:	eb 0d                	jmp    80101180 <balloc>
80101173:	90                   	nop
80101174:	90                   	nop
80101175:	90                   	nop
80101176:	90                   	nop
80101177:	90                   	nop
80101178:	90                   	nop
80101179:	90                   	nop
8010117a:	90                   	nop
8010117b:	90                   	nop
8010117c:	90                   	nop
8010117d:	90                   	nop
8010117e:	90                   	nop
8010117f:	90                   	nop

80101180 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 2c             	sub    $0x2c,%esp
80101189:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101191:	85 c0                	test   %eax,%eax
80101193:	0f 84 8c 00 00 00    	je     80101225 <balloc+0xa5>
80101199:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a3:	89 f0                	mov    %esi,%eax
801011a5:	c1 f8 0c             	sar    $0xc,%eax
801011a8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801011b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011b5:	89 04 24             	mov    %eax,(%esp)
801011b8:	e8 13 ef ff ff       	call   801000d0 <bread>
801011bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011c0:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011c8:	31 c0                	xor    %eax,%eax
801011ca:	eb 33                	jmp    801011ff <balloc+0x7f>
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011d3:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011d5:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d7:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	bf 01 00 00 00       	mov    $0x1,%edi
801011e2:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011e9:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011eb:	0f b6 fb             	movzbl %bl,%edi
801011ee:	85 cf                	test   %ecx,%edi
801011f0:	74 46                	je     80101238 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f2:	83 c0 01             	add    $0x1,%eax
801011f5:	83 c6 01             	add    $0x1,%esi
801011f8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fd:	74 05                	je     80101204 <balloc+0x84>
801011ff:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101202:	72 cc                	jb     801011d0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101207:	89 04 24             	mov    %eax,(%esp)
8010120a:	e8 d1 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010120f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010121f:	0f 82 7b ff ff ff    	jb     801011a0 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101225:	c7 04 24 f2 6d 10 80 	movl   $0x80106df2,(%esp)
8010122c:	e8 2f f1 ff ff       	call   80100360 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101238:	09 d9                	or     %ebx,%ecx
8010123a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010123d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101241:	89 1c 24             	mov    %ebx,(%esp)
80101244:	e8 67 1b 00 00       	call   80102db0 <log_write>
        brelse(bp);
80101249:	89 1c 24             	mov    %ebx,(%esp)
8010124c:	e8 8f ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101251:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101254:	89 74 24 04          	mov    %esi,0x4(%esp)
80101258:	89 04 24             	mov    %eax,(%esp)
8010125b:	e8 70 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101260:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101267:	00 
80101268:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010126f:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101270:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101272:	8d 40 5c             	lea    0x5c(%eax),%eax
80101275:	89 04 24             	mov    %eax,(%esp)
80101278:	e8 53 31 00 00       	call   801043d0 <memset>
  log_write(bp);
8010127d:	89 1c 24             	mov    %ebx,(%esp)
80101280:	e8 2b 1b 00 00       	call   80102db0 <log_write>
  brelse(bp);
80101285:	89 1c 24             	mov    %ebx,(%esp)
80101288:	e8 53 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010128d:	83 c4 2c             	add    $0x2c,%esp
80101290:	89 f0                	mov    %esi,%eax
80101292:	5b                   	pop    %ebx
80101293:	5e                   	pop    %esi
80101294:	5f                   	pop    %edi
80101295:	5d                   	pop    %ebp
80101296:	c3                   	ret    
80101297:	89 f6                	mov    %esi,%esi
80101299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	89 c7                	mov    %eax,%edi
801012a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012a7:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a9:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012aa:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012af:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801012b2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801012bc:	e8 4f 30 00 00       	call   80104310 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012c4:	eb 14                	jmp    801012da <iget+0x3a>
801012c6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012c8:	85 f6                	test   %esi,%esi
801012ca:	74 3c                	je     80101308 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012cc:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012d2:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012d8:	74 46                	je     80101320 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012da:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	7e e7                	jle    801012c8 <iget+0x28>
801012e1:	39 3b                	cmp    %edi,(%ebx)
801012e3:	75 e3                	jne    801012c8 <iget+0x28>
801012e5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012e8:	75 de                	jne    801012c8 <iget+0x28>
      ip->ref++;
801012ea:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012ed:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012f6:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012f9:	e8 82 30 00 00       	call   80104380 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012fe:	83 c4 1c             	add    $0x1c,%esp
80101301:	89 f0                	mov    %esi,%eax
80101303:	5b                   	pop    %ebx
80101304:	5e                   	pop    %esi
80101305:	5f                   	pop    %edi
80101306:	5d                   	pop    %ebp
80101307:	c3                   	ret    
80101308:	85 c9                	test   %ecx,%ecx
8010130a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101313:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101319:	75 bf                	jne    801012da <iget+0x3a>
8010131b:	90                   	nop
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101320:	85 f6                	test   %esi,%esi
80101322:	74 29                	je     8010134d <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101324:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101326:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101329:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101330:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101337:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010133e:	e8 3d 30 00 00       	call   80104380 <release>

  return ip;
}
80101343:	83 c4 1c             	add    $0x1c,%esp
80101346:	89 f0                	mov    %esi,%eax
80101348:	5b                   	pop    %ebx
80101349:	5e                   	pop    %esi
8010134a:	5f                   	pop    %edi
8010134b:	5d                   	pop    %ebp
8010134c:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
8010134d:	c7 04 24 08 6e 10 80 	movl   $0x80106e08,(%esp)
80101354:	e8 07 f0 ff ff       	call   80100360 <panic>
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c3                	mov    %eax,%ebx
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 46 5c             	mov    0x5c(%esi),%eax
80101376:	85 c0                	test   %eax,%eax
80101378:	74 66                	je     801013e0 <bmap+0x80>
	  return addr;
  }
 */

  panic("bmap: out of range");
}
8010137a:	83 c4 1c             	add    $0x1c,%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }

  bn -= NDIRECT;
80101388:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
8010138b:	83 fe 7f             	cmp    $0x7f,%esi
8010138e:	77 77                	ja     80101407 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101390:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101396:	85 c0                	test   %eax,%eax
80101398:	74 5e                	je     801013f8 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010139a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010139e:	8b 03                	mov    (%ebx),%eax
801013a0:	89 04 24             	mov    %eax,(%esp)
801013a3:	e8 28 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013a8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013ac:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013ae:	8b 32                	mov    (%edx),%esi
801013b0:	85 f6                	test   %esi,%esi
801013b2:	75 19                	jne    801013cd <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
801013b4:	8b 03                	mov    (%ebx),%eax
801013b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013b9:	e8 c2 fd ff ff       	call   80101180 <balloc>
801013be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013c1:	89 02                	mov    %eax,(%edx)
801013c3:	89 c6                	mov    %eax,%esi
      log_write(bp);
801013c5:	89 3c 24             	mov    %edi,(%esp)
801013c8:	e8 e3 19 00 00       	call   80102db0 <log_write>
    }
    brelse(bp);
801013cd:	89 3c 24             	mov    %edi,(%esp)
801013d0:	e8 0b ee ff ff       	call   801001e0 <brelse>
	  return addr;
  }
 */

  panic("bmap: out of range");
}
801013d5:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013d8:	89 f0                	mov    %esi,%eax
	  return addr;
  }
 */

  panic("bmap: out of range");
}
801013da:	5b                   	pop    %ebx
801013db:	5e                   	pop    %esi
801013dc:	5f                   	pop    %edi
801013dd:	5d                   	pop    %ebp
801013de:	c3                   	ret    
801013df:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013e0:	8b 03                	mov    (%ebx),%eax
801013e2:	e8 99 fd ff ff       	call   80101180 <balloc>
801013e7:	89 46 5c             	mov    %eax,0x5c(%esi)
	  return addr;
  }
 */

  panic("bmap: out of range");
}
801013ea:	83 c4 1c             	add    $0x1c,%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013f8:	8b 03                	mov    (%ebx),%eax
801013fa:	e8 81 fd ff ff       	call   80101180 <balloc>
801013ff:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101405:	eb 93                	jmp    8010139a <bmap+0x3a>
	  brelse(bp);
	  return addr;
  }
 */

  panic("bmap: out of range");
80101407:	c7 04 24 18 6e 10 80 	movl   $0x80106e18,(%esp)
8010140e:	e8 4d ef ff ff       	call   80100360 <panic>
80101413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101420 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101428:	8b 45 08             	mov    0x8(%ebp),%eax
8010142b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101432:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101433:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101436:	89 04 24             	mov    %eax,(%esp)
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010143e:	89 34 24             	mov    %esi,(%esp)
80101441:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101448:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
80101449:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010144b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010144e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101452:	e8 19 30 00 00       	call   80104470 <memmove>
  brelse(bp);
80101457:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010145a:	83 c4 10             	add    $0x10,%esp
8010145d:	5b                   	pop    %ebx
8010145e:	5e                   	pop    %esi
8010145f:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101460:	e9 7b ed ff ff       	jmp    801001e0 <brelse>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101479:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	c7 44 24 04 2b 6e 10 	movl   $0x80106e2b,0x4(%esp)
80101483:	80 
80101484:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010148b:	e8 10 2d 00 00       	call   801041a0 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	89 1c 24             	mov    %ebx,(%esp)
80101493:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101499:	c7 44 24 04 32 6e 10 	movl   $0x80106e32,0x4(%esp)
801014a0:	80 
801014a1:	e8 ca 2b 00 00       	call   80104070 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014ac:	75 e2                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014b8:	80 
801014b9:	89 04 24             	mov    %eax,(%esp)
801014bc:	e8 5f ff ff ff       	call   80101420 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014c1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014c6:	c7 04 24 98 6e 10 80 	movl   $0x80106e98,(%esp)
801014cd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014d1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014d6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014da:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014df:	89 44 24 14          	mov    %eax,0x14(%esp)
801014e3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014e8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014ec:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801014f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014f5:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801014fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801014fe:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101503:	89 44 24 04          	mov    %eax,0x4(%esp)
80101507:	e8 44 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010150c:	83 c4 24             	add    $0x24,%esp
8010150f:	5b                   	pop    %ebx
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
80101512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101520 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 2c             	sub    $0x2c,%esp
80101529:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101533:	8b 7d 08             	mov    0x8(%ebp),%edi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 a2 00 00 00    	jbe    801015e1 <ialloc+0xc1>
8010153f:	be 01 00 00 00       	mov    $0x1,%esi
80101544:	bb 01 00 00 00       	mov    $0x1,%ebx
80101549:	eb 1a                	jmp    80101565 <ialloc+0x45>
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101550:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101556:	e8 85 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010155b:	89 de                	mov    %ebx,%esi
8010155d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101563:	73 7c                	jae    801015e1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101565:	89 f0                	mov    %esi,%eax
80101567:	c1 e8 03             	shr    $0x3,%eax
8010156a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101570:	89 3c 24             	mov    %edi,(%esp)
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 f0                	mov    %esi,%eax
80101580:	83 e0 07             	and    $0x7,%eax
80101583:	c1 e0 06             	shl    $0x6,%eax
80101586:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010158e:	75 c0                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101590:	89 0c 24             	mov    %ecx,(%esp)
80101593:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010159a:	00 
8010159b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015a2:	00 
801015a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	e8 22 2e 00 00       	call   801043d0 <memset>
      dip->type = type;
801015ae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015bb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015be:	89 14 24             	mov    %edx,(%esp)
801015c1:	e8 ea 17 00 00       	call   80102db0 <log_write>
      brelse(bp);
801015c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015c9:	89 14 24             	mov    %edx,(%esp)
801015cc:	e8 0f ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d9:	5e                   	pop    %esi
801015da:	5f                   	pop    %edi
801015db:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015dc:	e9 bf fc ff ff       	jmp    801012a0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015e1:	c7 04 24 38 6e 10 80 	movl   $0x80106e38,(%esp)
801015e8:	e8 73 ed ff ff       	call   80100360 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	83 ec 10             	sub    $0x10,%esp
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 b7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101619:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010161c:	83 e2 07             	and    $0x7,%edx
8010161f:	c1 e2 06             	shl    $0x6,%edx
80101622:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101626:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101628:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010162f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101633:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101637:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010163b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010163f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101643:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101647:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010164b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010164e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101651:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101655:	89 14 24             	mov    %edx,(%esp)
80101658:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010165f:	00 
80101660:	e8 0b 2e 00 00       	call   80104470 <memmove>
  log_write(bp);
80101665:	89 34 24             	mov    %esi,(%esp)
80101668:	e8 43 17 00 00       	call   80102db0 <log_write>
  brelse(bp);
8010166d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101670:	83 c4 10             	add    $0x10,%esp
80101673:	5b                   	pop    %ebx
80101674:	5e                   	pop    %esi
80101675:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101676:	e9 65 eb ff ff       	jmp    801001e0 <brelse>
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 14             	sub    $0x14,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101691:	e8 7a 2c 00 00       	call   80104310 <acquire>
  ip->ref++;
80101696:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 da 2c 00 00       	call   80104380 <release>
  return ip;
}
801016a6:	83 c4 14             	add    $0x14,%esp
801016a9:	89 d8                	mov    %ebx,%eax
801016ab:	5b                   	pop    %ebx
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax

801016b0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 10             	sub    $0x10,%esp
801016b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016bb:	85 db                	test   %ebx,%ebx
801016bd:	0f 84 b3 00 00 00    	je     80101776 <ilock+0xc6>
801016c3:	8b 53 08             	mov    0x8(%ebx),%edx
801016c6:	85 d2                	test   %edx,%edx
801016c8:	0f 8e a8 00 00 00    	jle    80101776 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 d7 29 00 00       	call   801040b0 <acquiresleep>

  if(ip->valid == 0){
801016d9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016dc:	85 c0                	test   %eax,%eax
801016de:	74 08                	je     801016e8 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016e0:	83 c4 10             	add    $0x10,%esp
801016e3:	5b                   	pop    %ebx
801016e4:	5e                   	pop    %esi
801016e5:	5d                   	pop    %ebp
801016e6:	c3                   	ret    
801016e7:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
801016eb:	c1 e8 03             	shr    $0x3,%eax
801016ee:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016f8:	8b 03                	mov    (%ebx),%eax
801016fa:	89 04 24             	mov    %eax,(%esp)
801016fd:	e8 ce e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101702:	8b 53 04             	mov    0x4(%ebx),%edx
80101705:	83 e2 07             	and    $0x7,%edx
80101708:	c1 e2 06             	shl    $0x6,%edx
8010170b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101711:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101714:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101717:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010171b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010171f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101723:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101727:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010172b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010172f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101733:	8b 42 fc             	mov    -0x4(%edx),%eax
80101736:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101739:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010173c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101740:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101747:	00 
80101748:	89 04 24             	mov    %eax,(%esp)
8010174b:	e8 20 2d 00 00       	call   80104470 <memmove>
    brelse(bp);
80101750:	89 34 24             	mov    %esi,(%esp)
80101753:	e8 88 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101758:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010175d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101764:	0f 85 76 ff ff ff    	jne    801016e0 <ilock+0x30>
      panic("ilock: no type");
8010176a:	c7 04 24 50 6e 10 80 	movl   $0x80106e50,(%esp)
80101771:	e8 ea eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101776:	c7 04 24 4a 6e 10 80 	movl   $0x80106e4a,(%esp)
8010177d:	e8 de eb ff ff       	call   80100360 <panic>
80101782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101790 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	83 ec 10             	sub    $0x10,%esp
80101798:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010179b:	85 db                	test   %ebx,%ebx
8010179d:	74 24                	je     801017c3 <iunlock+0x33>
8010179f:	8d 73 0c             	lea    0xc(%ebx),%esi
801017a2:	89 34 24             	mov    %esi,(%esp)
801017a5:	e8 a6 29 00 00       	call   80104150 <holdingsleep>
801017aa:	85 c0                	test   %eax,%eax
801017ac:	74 15                	je     801017c3 <iunlock+0x33>
801017ae:	8b 43 08             	mov    0x8(%ebx),%eax
801017b1:	85 c0                	test   %eax,%eax
801017b3:	7e 0e                	jle    801017c3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017b5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	5b                   	pop    %ebx
801017bc:	5e                   	pop    %esi
801017bd:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017be:	e9 4d 29 00 00       	jmp    80104110 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017c3:	c7 04 24 5f 6e 10 80 	movl   $0x80106e5f,(%esp)
801017ca:	e8 91 eb ff ff       	call   80100360 <panic>
801017cf:	90                   	nop

801017d0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 1c             	sub    $0x1c,%esp
801017d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017dc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017df:	89 3c 24             	mov    %edi,(%esp)
801017e2:	e8 c9 28 00 00       	call   801040b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017e7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017ea:	85 d2                	test   %edx,%edx
801017ec:	74 07                	je     801017f5 <iput+0x25>
801017ee:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017f3:	74 2b                	je     80101820 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017f5:	89 3c 24             	mov    %edi,(%esp)
801017f8:	e8 13 29 00 00       	call   80104110 <releasesleep>

  acquire(&icache.lock);
801017fd:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101804:	e8 07 2b 00 00       	call   80104310 <acquire>
  ip->ref--;
80101809:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010180d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101814:	83 c4 1c             	add    $0x1c,%esp
80101817:	5b                   	pop    %ebx
80101818:	5e                   	pop    %esi
80101819:	5f                   	pop    %edi
8010181a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010181b:	e9 60 2b 00 00       	jmp    80104380 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101820:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101827:	e8 e4 2a 00 00       	call   80104310 <acquire>
    int r = ip->ref;
8010182c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010182f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101836:	e8 45 2b 00 00       	call   80104380 <release>
    if(r == 1){
8010183b:	83 fb 01             	cmp    $0x1,%ebx
8010183e:	75 b5                	jne    801017f5 <iput+0x25>
80101840:	8d 4e 30             	lea    0x30(%esi),%ecx
80101843:	89 f3                	mov    %esi,%ebx
80101845:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x87>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fb                	cmp    %edi,%ebx
80101855:	74 19                	je     80101870 <iput+0xa0>
    if(ip->addrs[i]){
80101857:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010185a:	85 d2                	test   %edx,%edx
8010185c:	74 f2                	je     80101850 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010185e:	8b 06                	mov    (%esi),%eax
80101860:	e8 9b f8 ff ff       	call   80101100 <bfree>
      ip->addrs[i] = 0;
80101865:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010186c:	eb e2                	jmp    80101850 <iput+0x80>
8010186e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 2b                	jne    801018a8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010187d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101884:	89 34 24             	mov    %esi,(%esp)
80101887:	e8 64 fd ff ff       	call   801015f0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010188c:	31 c0                	xor    %eax,%eax
8010188e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101892:	89 34 24             	mov    %esi,(%esp)
80101895:	e8 56 fd ff ff       	call   801015f0 <iupdate>
      ip->valid = 0;
8010189a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018a1:	e9 4f ff ff ff       	jmp    801017f5 <iput+0x25>
801018a6:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018ac:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018ae:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	89 04 24             	mov    %eax,(%esp)
801018b3:	e8 18 e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018b8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
801018bb:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018c1:	89 cf                	mov    %ecx,%edi
801018c3:	31 c0                	xor    %eax,%eax
801018c5:	eb 0e                	jmp    801018d5 <iput+0x105>
801018c7:	90                   	nop
801018c8:	83 c3 01             	add    $0x1,%ebx
801018cb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018d1:	89 d8                	mov    %ebx,%eax
801018d3:	74 10                	je     801018e5 <iput+0x115>
      if(a[j])
801018d5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018d8:	85 d2                	test   %edx,%edx
801018da:	74 ec                	je     801018c8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018dc:	8b 06                	mov    (%esi),%eax
801018de:	e8 1d f8 ff ff       	call   80101100 <bfree>
801018e3:	eb e3                	jmp    801018c8 <iput+0xf8>
    }
    brelse(bp);
801018e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018e8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018eb:	89 04 24             	mov    %eax,(%esp)
801018ee:	e8 ed e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018f3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018f9:	8b 06                	mov    (%esi),%eax
801018fb:	e8 00 f8 ff ff       	call   80101100 <bfree>
    ip->addrs[NDIRECT] = 0;
80101900:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101907:	00 00 00 
8010190a:	e9 6e ff ff ff       	jmp    8010187d <iput+0xad>
8010190f:	90                   	nop

80101910 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 14             	sub    $0x14,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	89 1c 24             	mov    %ebx,(%esp)
8010191d:	e8 6e fe ff ff       	call   80101790 <iunlock>
  iput(ip);
80101922:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101925:	83 c4 14             	add    $0x14,%esp
80101928:	5b                   	pop    %ebx
80101929:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010192a:	e9 a1 fe ff ff       	jmp    801017d0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 2c             	sub    $0x2c,%esp
80101969:	8b 45 0c             	mov    0xc(%ebp),%eax
8010196c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010196f:	8b 75 10             	mov    0x10(%ebp),%esi
80101972:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101975:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101978:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010197d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101980:	0f 84 aa 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101986:	8b 47 58             	mov    0x58(%edi),%eax
80101989:	39 f0                	cmp    %esi,%eax
8010198b:	0f 82 c7 00 00 00    	jb     80101a58 <readi+0xf8>
80101991:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101994:	89 da                	mov    %ebx,%edx
80101996:	01 f2                	add    %esi,%edx
80101998:	0f 82 ba 00 00 00    	jb     80101a58 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010199e:	89 c1                	mov    %eax,%ecx
801019a0:	29 f1                	sub    %esi,%ecx
801019a2:	39 d0                	cmp    %edx,%eax
801019a4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a7:	31 c0                	xor    %eax,%eax
801019a9:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ab:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ae:	74 70                	je     80101a20 <readi+0xc0>
801019b0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019b3:	89 c7                	mov    %eax,%edi
801019b5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019bb:	89 f2                	mov    %esi,%edx
801019bd:	c1 ea 09             	shr    $0x9,%edx
801019c0:	89 d8                	mov    %ebx,%eax
801019c2:	e8 99 f9 ff ff       	call   80101360 <bmap>
801019c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019cb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019cd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d2:	89 04 24             	mov    %eax,(%esp)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019dd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019df:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019e1:	89 f0                	mov    %esi,%eax
801019e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ea:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019ee:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019fe:	01 df                	add    %ebx,%edi
80101a00:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a05:	89 04 24             	mov    %eax,(%esp)
80101a08:	e8 63 2a 00 00       	call   80104470 <memmove>
    brelse(bp);
80101a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a10:	89 14 24             	mov    %edx,(%esp)
80101a13:	e8 c8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a18:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a1e:	77 98                	ja     801019b8 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a23:	83 c4 2c             	add    $0x2c,%esp
80101a26:	5b                   	pop    %ebx
80101a27:	5e                   	pop    %esi
80101a28:	5f                   	pop    %edi
80101a29:	5d                   	pop    %ebp
80101a2a:	c3                   	ret    
80101a2b:	90                   	nop
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 1e                	ja     80101a58 <readi+0xf8>
80101a3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 13                	je     80101a58 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a45:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a48:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a4b:	83 c4 2c             	add    $0x2c,%esp
80101a4e:	5b                   	pop    %ebx
80101a4f:	5e                   	pop    %esi
80101a50:	5f                   	pop    %edi
80101a51:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a52:	ff e0                	jmp    *%eax
80101a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a5d:	eb c4                	jmp    80101a23 <readi+0xc3>
80101a5f:	90                   	nop

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 2c             	sub    $0x2c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a80:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 e3 00 00 00    	jb     80101b78 <writei+0x118>
80101a95:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a98:	89 c8                	mov    %ecx,%eax
80101a9a:	01 f0                	add    %esi,%eax
80101a9c:	0f 82 d6 00 00 00    	jb     80101b78 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa7:	0f 87 cb 00 00 00    	ja     80101b78 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101aad:	85 c9                	test   %ecx,%ecx
80101aaf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ab6:	74 77                	je     80101b2f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101abb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101abd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac2:	c1 ea 09             	shr    $0x9,%edx
80101ac5:	89 f8                	mov    %edi,%eax
80101ac7:	e8 94 f8 ff ff       	call   80101360 <bmap>
80101acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ad0:	8b 07                	mov    (%edi),%eax
80101ad2:	89 04 24             	mov    %eax,(%esp)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101add:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ae0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae5:	89 f0                	mov    %esi,%eax
80101ae7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aec:	29 c3                	sub    %eax,%ebx
80101aee:	39 cb                	cmp    %ecx,%ebx
80101af0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af7:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101af9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101afd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b01:	89 04 24             	mov    %eax,(%esp)
80101b04:	e8 67 29 00 00       	call   80104470 <memmove>
    log_write(bp);
80101b09:	89 3c 24             	mov    %edi,(%esp)
80101b0c:	e8 9f 12 00 00       	call   80102db0 <log_write>
    brelse(bp);
80101b11:	89 3c 24             	mov    %edi,(%esp)
80101b14:	e8 c7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b19:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b1f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b22:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b25:	77 91                	ja     80101ab8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b27:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b2d:	72 39                	jb     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b32:	83 c4 2c             	add    $0x2c,%esp
80101b35:	5b                   	pop    %ebx
80101b36:	5e                   	pop    %esi
80101b37:	5f                   	pop    %edi
80101b38:	5d                   	pop    %ebp
80101b39:	c3                   	ret    
80101b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 2e                	ja     80101b78 <writei+0x118>
80101b4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 23                	je     80101b78 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b58:	83 c4 2c             	add    $0x2c,%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b6e:	89 04 24             	mov    %eax,(%esp)
80101b71:	e8 7a fa ff ff       	call   801015f0 <iupdate>
80101b76:	eb b7                	jmp    80101b2f <writei+0xcf>
  }
  return n;
}
80101b78:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b80:	5b                   	pop    %ebx
80101b81:	5e                   	pop    %esi
80101b82:	5f                   	pop    %edi
80101b83:	5d                   	pop    %ebp
80101b84:	c3                   	ret    
80101b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b99:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ba0:	00 
80101ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba8:	89 04 24             	mov    %eax,(%esp)
80101bab:	e8 40 29 00 00       	call   801044f0 <strncmp>
}
80101bb0:	c9                   	leave  
80101bb1:	c3                   	ret    
80101bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 2c             	sub    $0x2c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 97 00 00 00    	jne    80101c6e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	75 0d                	jne    80101bf0 <dirlookup+0x30>
80101be3:	eb 73                	jmp    80101c58 <dirlookup+0x98>
80101be5:	8d 76 00             	lea    0x0(%esi),%esi
80101be8:	83 c7 10             	add    $0x10,%edi
80101beb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bee:	76 68                	jbe    80101c58 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bf7:	00 
80101bf8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bfc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c00:	89 1c 24             	mov    %ebx,(%esp)
80101c03:	e8 58 fd ff ff       	call   80101960 <readi>
80101c08:	83 f8 10             	cmp    $0x10,%eax
80101c0b:	75 55                	jne    80101c62 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c0d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c12:	74 d4                	je     80101be8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c14:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c1e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c25:	00 
80101c26:	89 04 24             	mov    %eax,(%esp)
80101c29:	e8 c2 28 00 00       	call   801044f0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c2e:	85 c0                	test   %eax,%eax
80101c30:	75 b6                	jne    80101be8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c32:	8b 45 10             	mov    0x10(%ebp),%eax
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 05                	je     80101c3e <dirlookup+0x7e>
        *poff = off;
80101c39:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c42:	8b 03                	mov    (%ebx),%eax
80101c44:	e8 57 f6 ff ff       	call   801012a0 <iget>
    }
  }

  return 0;
}
80101c49:	83 c4 2c             	add    $0x2c,%esp
80101c4c:	5b                   	pop    %ebx
80101c4d:	5e                   	pop    %esi
80101c4e:	5f                   	pop    %edi
80101c4f:	5d                   	pop    %ebp
80101c50:	c3                   	ret    
80101c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c58:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c5b:	31 c0                	xor    %eax,%eax
}
80101c5d:	5b                   	pop    %ebx
80101c5e:	5e                   	pop    %esi
80101c5f:	5f                   	pop    %edi
80101c60:	5d                   	pop    %ebp
80101c61:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c62:	c7 04 24 79 6e 10 80 	movl   $0x80106e79,(%esp)
80101c69:	e8 f2 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c6e:	c7 04 24 67 6e 10 80 	movl   $0x80106e67,(%esp)
80101c75:	e8 e6 e6 ff ff       	call   80100360 <panic>
80101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	89 cf                	mov    %ecx,%edi
80101c86:	56                   	push   %esi
80101c87:	53                   	push   %ebx
80101c88:	89 c3                	mov    %eax,%ebx
80101c8a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c8d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c93:	0f 84 51 01 00 00    	je     80101dea <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c99:	e8 32 1a 00 00       	call   801036d0 <myproc>
80101c9e:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101ca1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ca8:	e8 63 26 00 00       	call   80104310 <acquire>
  ip->ref++;
80101cad:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb8:	e8 c3 26 00 00       	call   80104380 <release>
80101cbd:	eb 04                	jmp    80101cc3 <namex+0x43>
80101cbf:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cc0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cc3:	0f b6 03             	movzbl (%ebx),%eax
80101cc6:	3c 2f                	cmp    $0x2f,%al
80101cc8:	74 f6                	je     80101cc0 <namex+0x40>
    path++;
  if(*path == 0)
80101cca:	84 c0                	test   %al,%al
80101ccc:	0f 84 ed 00 00 00    	je     80101dbf <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cd2:	0f b6 03             	movzbl (%ebx),%eax
80101cd5:	89 da                	mov    %ebx,%edx
80101cd7:	84 c0                	test   %al,%al
80101cd9:	0f 84 b1 00 00 00    	je     80101d90 <namex+0x110>
80101cdf:	3c 2f                	cmp    $0x2f,%al
80101ce1:	75 0f                	jne    80101cf2 <namex+0x72>
80101ce3:	e9 a8 00 00 00       	jmp    80101d90 <namex+0x110>
80101ce8:	3c 2f                	cmp    $0x2f,%al
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cf0:	74 0a                	je     80101cfc <namex+0x7c>
    path++;
80101cf2:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cf5:	0f b6 02             	movzbl (%edx),%eax
80101cf8:	84 c0                	test   %al,%al
80101cfa:	75 ec                	jne    80101ce8 <namex+0x68>
80101cfc:	89 d1                	mov    %edx,%ecx
80101cfe:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d00:	83 f9 0d             	cmp    $0xd,%ecx
80101d03:	0f 8e 8f 00 00 00    	jle    80101d98 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d0d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d14:	00 
80101d15:	89 3c 24             	mov    %edi,(%esp)
80101d18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d1b:	e8 50 27 00 00       	call   80104470 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d23:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d25:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d28:	75 0e                	jne    80101d38 <namex+0xb8>
80101d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d36:	74 f8                	je     80101d30 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d38:	89 34 24             	mov    %esi,(%esp)
80101d3b:	e8 70 f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d40:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d45:	0f 85 85 00 00 00    	jne    80101dd0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d4e:	85 d2                	test   %edx,%edx
80101d50:	74 09                	je     80101d5b <namex+0xdb>
80101d52:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d55:	0f 84 a5 00 00 00    	je     80101e00 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d62:	00 
80101d63:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d67:	89 34 24             	mov    %esi,(%esp)
80101d6a:	e8 51 fe ff ff       	call   80101bc0 <dirlookup>
80101d6f:	85 c0                	test   %eax,%eax
80101d71:	74 5d                	je     80101dd0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d73:	89 34 24             	mov    %esi,(%esp)
80101d76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d79:	e8 12 fa ff ff       	call   80101790 <iunlock>
  iput(ip);
80101d7e:	89 34 24             	mov    %esi,(%esp)
80101d81:	e8 4a fa ff ff       	call   801017d0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d89:	89 c6                	mov    %eax,%esi
80101d8b:	e9 33 ff ff ff       	jmp    80101cc3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d90:	31 c9                	xor    %ecx,%ecx
80101d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d98:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d9c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101da0:	89 3c 24             	mov    %edi,(%esp)
80101da3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da9:	e8 c2 26 00 00       	call   80104470 <memmove>
    name[len] = 0;
80101dae:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101db4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101db8:	89 d3                	mov    %edx,%ebx
80101dba:	e9 66 ff ff ff       	jmp    80101d25 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dc2:	85 c0                	test   %eax,%eax
80101dc4:	75 4c                	jne    80101e12 <namex+0x192>
80101dc6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc8:	83 c4 2c             	add    $0x2c,%esp
80101dcb:	5b                   	pop    %ebx
80101dcc:	5e                   	pop    %esi
80101dcd:	5f                   	pop    %edi
80101dce:	5d                   	pop    %ebp
80101dcf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dd0:	89 34 24             	mov    %esi,(%esp)
80101dd3:	e8 b8 f9 ff ff       	call   80101790 <iunlock>
  iput(ip);
80101dd8:	89 34 24             	mov    %esi,(%esp)
80101ddb:	e8 f0 f9 ff ff       	call   801017d0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101de3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de5:	5b                   	pop    %ebx
80101de6:	5e                   	pop    %esi
80101de7:	5f                   	pop    %edi
80101de8:	5d                   	pop    %ebp
80101de9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dea:	ba 01 00 00 00       	mov    $0x1,%edx
80101def:	b8 01 00 00 00       	mov    $0x1,%eax
80101df4:	e8 a7 f4 ff ff       	call   801012a0 <iget>
80101df9:	89 c6                	mov    %eax,%esi
80101dfb:	e9 c3 fe ff ff       	jmp    80101cc3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e00:	89 34 24             	mov    %esi,(%esp)
80101e03:	e8 88 f9 ff ff       	call   80101790 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e08:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e0b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e0d:	5b                   	pop    %ebx
80101e0e:	5e                   	pop    %esi
80101e0f:	5f                   	pop    %edi
80101e10:	5d                   	pop    %ebp
80101e11:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e12:	89 34 24             	mov    %esi,(%esp)
80101e15:	e8 b6 f9 ff ff       	call   801017d0 <iput>
    return 0;
80101e1a:	31 c0                	xor    %eax,%eax
80101e1c:	eb aa                	jmp    80101dc8 <namex+0x148>
80101e1e:	66 90                	xchg   %ax,%ax

80101e20 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 2c             	sub    $0x2c,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e36:	00 
80101e37:	89 1c 24             	mov    %ebx,(%esp)
80101e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e3e:	e8 7d fd ff ff       	call   80101bc0 <dirlookup>
80101e43:	85 c0                	test   %eax,%eax
80101e45:	0f 85 8b 00 00 00    	jne    80101ed6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e4e:	31 ff                	xor    %edi,%edi
80101e50:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e53:	85 c0                	test   %eax,%eax
80101e55:	75 13                	jne    80101e6a <dirlink+0x4a>
80101e57:	eb 35                	jmp    80101e8e <dirlink+0x6e>
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e60:	8d 57 10             	lea    0x10(%edi),%edx
80101e63:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e66:	89 d7                	mov    %edx,%edi
80101e68:	76 24                	jbe    80101e8e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e71:	00 
80101e72:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e76:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e7a:	89 1c 24             	mov    %ebx,(%esp)
80101e7d:	e8 de fa ff ff       	call   80101960 <readi>
80101e82:	83 f8 10             	cmp    $0x10,%eax
80101e85:	75 5e                	jne    80101ee5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e87:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8c:	75 d2                	jne    80101e60 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e91:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e98:	00 
80101e99:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e9d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ea0:	89 04 24             	mov    %eax,(%esp)
80101ea3:	e8 b8 26 00 00       	call   80104560 <strncpy>
  de.inum = inum;
80101ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eab:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101eb2:	00 
80101eb3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101eb7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ebb:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101ebe:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec2:	e8 99 fb ff ff       	call   80101a60 <writei>
80101ec7:	83 f8 10             	cmp    $0x10,%eax
80101eca:	75 25                	jne    80101ef1 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101ecc:	31 c0                	xor    %eax,%eax
}
80101ece:	83 c4 2c             	add    $0x2c,%esp
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ed6:	89 04 24             	mov    %eax,(%esp)
80101ed9:	e8 f2 f8 ff ff       	call   801017d0 <iput>
    return -1;
80101ede:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee3:	eb e9                	jmp    80101ece <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ee5:	c7 04 24 88 6e 10 80 	movl   $0x80106e88,(%esp)
80101eec:	e8 6f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ef1:	c7 04 24 7e 74 10 80 	movl   $0x8010747e,(%esp)
80101ef8:	e8 63 e4 ff ff       	call   80100360 <panic>
80101efd:	8d 76 00             	lea    0x0(%esi),%esi

80101f00 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f00:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f01:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f0e:	e8 6d fd ff ff       	call   80101c80 <namex>
}
80101f13:	c9                   	leave  
80101f14:	c3                   	ret    
80101f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f20:	55                   	push   %ebp
  return namex(path, 1, name);
80101f21:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f26:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f2e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f2f:	e9 4c fd ff ff       	jmp    80101c80 <namex>
80101f34:	66 90                	xchg   %ax,%ax
80101f36:	66 90                	xchg   %ax,%ax
80101f38:	66 90                	xchg   %ax,%ax
80101f3a:	66 90                	xchg   %ax,%ax
80101f3c:	66 90                	xchg   %ax,%ax
80101f3e:	66 90                	xchg   %ax,%ax

80101f40 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	56                   	push   %esi
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	53                   	push   %ebx
80101f47:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f4a:	85 c0                	test   %eax,%eax
80101f4c:	0f 84 99 00 00 00    	je     80101feb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f52:	8b 48 08             	mov    0x8(%eax),%ecx
80101f55:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f5b:	0f 87 7e 00 00 00    	ja     80101fdf <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f61:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f66:	66 90                	xchg   %ax,%ax
80101f68:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f69:	83 e0 c0             	and    $0xffffffc0,%eax
80101f6c:	3c 40                	cmp    $0x40,%al
80101f6e:	75 f8                	jne    80101f68 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f70:	31 db                	xor    %ebx,%ebx
80101f72:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ee                   	out    %al,(%dx)
80101f7a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f84:	ee                   	out    %al,(%dx)
80101f85:	0f b6 c1             	movzbl %cl,%eax
80101f88:	b2 f3                	mov    $0xf3,%dl
80101f8a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f8b:	89 c8                	mov    %ecx,%eax
80101f8d:	b2 f4                	mov    $0xf4,%dl
80101f8f:	c1 f8 08             	sar    $0x8,%eax
80101f92:	ee                   	out    %al,(%dx)
80101f93:	b2 f5                	mov    $0xf5,%dl
80101f95:	89 d8                	mov    %ebx,%eax
80101f97:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f98:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9c:	b2 f6                	mov    $0xf6,%dl
80101f9e:	83 e0 01             	and    $0x1,%eax
80101fa1:	c1 e0 04             	shl    $0x4,%eax
80101fa4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fa7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fa8:	f6 06 04             	testb  $0x4,(%esi)
80101fab:	75 13                	jne    80101fc0 <idestart+0x80>
80101fad:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5d                   	pop    %ebp
80101fbe:	c3                   	ret    
80101fbf:	90                   	nop
80101fc0:	b2 f7                	mov    $0xf7,%dl
80101fc2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fc7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fc8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fcd:	83 c6 5c             	add    $0x5c,%esi
80101fd0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fd5:	fc                   	cld    
80101fd6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fdf:	c7 04 24 f4 6e 10 80 	movl   $0x80106ef4,(%esp)
80101fe6:	e8 75 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101feb:	c7 04 24 eb 6e 10 80 	movl   $0x80106eeb,(%esp)
80101ff2:	e8 69 e3 ff ff       	call   80100360 <panic>
80101ff7:	89 f6                	mov    %esi,%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102006:	c7 44 24 04 06 6f 10 	movl   $0x80106f06,0x4(%esp)
8010200d:	80 
8010200e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102015:	e8 86 21 00 00       	call   801041a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010201a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010201f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102026:	83 e8 01             	sub    $0x1,%eax
80102029:	89 44 24 04          	mov    %eax,0x4(%esp)
8010202d:	e8 7e 02 00 00       	call   801022b0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102032:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102037:	90                   	nop
80102038:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102039:	83 e0 c0             	and    $0xffffffc0,%eax
8010203c:	3c 40                	cmp    $0x40,%al
8010203e:	75 f8                	jne    80102038 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102040:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102045:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204a:	ee                   	out    %al,(%dx)
8010204b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102050:	b2 f7                	mov    $0xf7,%dl
80102052:	eb 09                	jmp    8010205d <ideinit+0x5d>
80102054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102058:	83 e9 01             	sub    $0x1,%ecx
8010205b:	74 0f                	je     8010206c <ideinit+0x6c>
8010205d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010205e:	84 c0                	test   %al,%al
80102060:	74 f6                	je     80102058 <ideinit+0x58>
      havedisk1 = 1;
80102062:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102069:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010206c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102071:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102076:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102077:	c9                   	leave  
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102080 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102090:	e8 7b 22 00 00       	call   80104310 <acquire>

  if((b = idequeue) == 0){
80102095:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010209b:	85 db                	test   %ebx,%ebx
8010209d:	74 30                	je     801020cf <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010209f:	8b 43 58             	mov    0x58(%ebx),%eax
801020a2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a7:	8b 33                	mov    (%ebx),%esi
801020a9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020af:	74 37                	je     801020e8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020b1:	83 e6 fb             	and    $0xfffffffb,%esi
801020b4:	83 ce 02             	or     $0x2,%esi
801020b7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020b9:	89 1c 24             	mov    %ebx,(%esp)
801020bc:	e8 cf 1d 00 00       	call   80103e90 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020c1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020c6:	85 c0                	test   %eax,%eax
801020c8:	74 05                	je     801020cf <ideintr+0x4f>
    idestart(idequeue);
801020ca:	e8 71 fe ff ff       	call   80101f40 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020cf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020d6:	e8 a5 22 00 00       	call   80104380 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020db:	83 c4 1c             	add    $0x1c,%esp
801020de:	5b                   	pop    %ebx
801020df:	5e                   	pop    %esi
801020e0:	5f                   	pop    %edi
801020e1:	5d                   	pop    %ebp
801020e2:	c3                   	ret    
801020e3:	90                   	nop
801020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ed:	8d 76 00             	lea    0x0(%esi),%esi
801020f0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	89 c1                	mov    %eax,%ecx
801020f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020f6:	80 f9 40             	cmp    $0x40,%cl
801020f9:	75 f5                	jne    801020f0 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020fb:	a8 21                	test   $0x21,%al
801020fd:	75 b2                	jne    801020b1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102102:	b9 80 00 00 00       	mov    $0x80,%ecx
80102107:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210c:	fc                   	cld    
8010210d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010210f:	8b 33                	mov    (%ebx),%esi
80102111:	eb 9e                	jmp    801020b1 <ideintr+0x31>
80102113:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 14             	sub    $0x14,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	89 04 24             	mov    %eax,(%esp)
80102130:	e8 1b 20 00 00       	call   80104150 <holdingsleep>
80102135:	85 c0                	test   %eax,%eax
80102137:	0f 84 9e 00 00 00    	je     801021db <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213d:	8b 03                	mov    (%ebx),%eax
8010213f:	83 e0 06             	and    $0x6,%eax
80102142:	83 f8 02             	cmp    $0x2,%eax
80102145:	0f 84 a8 00 00 00    	je     801021f3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214b:	8b 53 04             	mov    0x4(%ebx),%edx
8010214e:	85 d2                	test   %edx,%edx
80102150:	74 0d                	je     8010215f <iderw+0x3f>
80102152:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102157:	85 c0                	test   %eax,%eax
80102159:	0f 84 88 00 00 00    	je     801021e7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010215f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102166:	e8 a5 21 00 00       	call   80104310 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102170:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102177:	85 c0                	test   %eax,%eax
80102179:	75 07                	jne    80102182 <iderw+0x62>
8010217b:	eb 4e                	jmp    801021cb <iderw+0xab>
8010217d:	8d 76 00             	lea    0x0(%esi),%esi
80102180:	89 d0                	mov    %edx,%eax
80102182:	8b 50 58             	mov    0x58(%eax),%edx
80102185:	85 d2                	test   %edx,%edx
80102187:	75 f7                	jne    80102180 <iderw+0x60>
80102189:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010218c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010218e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102194:	74 3c                	je     801021d2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102196:	8b 03                	mov    (%ebx),%eax
80102198:	83 e0 06             	and    $0x6,%eax
8010219b:	83 f8 02             	cmp    $0x2,%eax
8010219e:	74 1a                	je     801021ba <iderw+0x9a>
    sleep(b, &idelock);
801021a0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021a7:	80 
801021a8:	89 1c 24             	mov    %ebx,(%esp)
801021ab:	e8 50 1b 00 00       	call   80103d00 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021b0:	8b 13                	mov    (%ebx),%edx
801021b2:	83 e2 06             	and    $0x6,%edx
801021b5:	83 fa 02             	cmp    $0x2,%edx
801021b8:	75 e6                	jne    801021a0 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
801021ba:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021c1:	83 c4 14             	add    $0x14,%esp
801021c4:	5b                   	pop    %ebx
801021c5:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021c6:	e9 b5 21 00 00       	jmp    80104380 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021cb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021d0:	eb ba                	jmp    8010218c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021d2:	89 d8                	mov    %ebx,%eax
801021d4:	e8 67 fd ff ff       	call   80101f40 <idestart>
801021d9:	eb bb                	jmp    80102196 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021db:	c7 04 24 0a 6f 10 80 	movl   $0x80106f0a,(%esp)
801021e2:	e8 79 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021e7:	c7 04 24 35 6f 10 80 	movl   $0x80106f35,(%esp)
801021ee:	e8 6d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021f3:	c7 04 24 20 6f 10 80 	movl   $0x80106f20,(%esp)
801021fa:	e8 61 e1 ff ff       	call   80100360 <panic>
801021ff:	90                   	nop

80102200 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	56                   	push   %esi
80102204:	53                   	push   %ebx
80102205:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102208:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010220f:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102212:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102219:	00 00 00 
  return ioapic->data;
8010221c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102222:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102225:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010222b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102231:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102238:	c1 e8 10             	shr    $0x10,%eax
8010223b:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010223e:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
80102241:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102244:	39 c2                	cmp    %eax,%edx
80102246:	74 12                	je     8010225a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102248:	c7 04 24 54 6f 10 80 	movl   $0x80106f54,(%esp)
8010224f:	e8 fc e3 ff ff       	call   80100650 <cprintf>
80102254:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010225a:	ba 10 00 00 00       	mov    $0x10,%edx
8010225f:	31 c0                	xor    %eax,%eax
80102261:	eb 07                	jmp    8010226a <ioapicinit+0x6a>
80102263:	90                   	nop
80102264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102268:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010226a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010226c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102272:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102275:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227b:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010227e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102281:	8d 4a 01             	lea    0x1(%edx),%ecx
80102284:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102287:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102289:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228f:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102291:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102298:	7d ce                	jge    80102268 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010229a:	83 c4 10             	add    $0x10,%esp
8010229d:	5b                   	pop    %ebx
8010229e:	5e                   	pop    %esi
8010229f:	5d                   	pop    %ebp
801022a0:	c3                   	ret    
801022a1:	eb 0d                	jmp    801022b0 <ioapicenable>
801022a3:	90                   	nop
801022a4:	90                   	nop
801022a5:	90                   	nop
801022a6:	90                   	nop
801022a7:	90                   	nop
801022a8:	90                   	nop
801022a9:	90                   	nop
801022aa:	90                   	nop
801022ab:	90                   	nop
801022ac:	90                   	nop
801022ad:	90                   	nop
801022ae:	90                   	nop
801022af:	90                   	nop

801022b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	8b 55 08             	mov    0x8(%ebp),%edx
801022b6:	53                   	push   %ebx
801022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ba:	8d 5a 20             	lea    0x20(%edx),%ebx
801022bd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c7:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ca:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022cc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d2:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022d5:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022d8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022da:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022e0:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022e3:	5b                   	pop    %ebx
801022e4:	5d                   	pop    %ebp
801022e5:	c3                   	ret    
801022e6:	66 90                	xchg   %ax,%ax
801022e8:	66 90                	xchg   %ax,%ax
801022ea:	66 90                	xchg   %ax,%ax
801022ec:	66 90                	xchg   %ax,%ax
801022ee:	66 90                	xchg   %ax,%ax

801022f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 14             	sub    $0x14,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102300:	75 7c                	jne    8010237e <kfree+0x8e>
80102302:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102308:	72 74                	jb     8010237e <kfree+0x8e>
8010230a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102310:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102315:	77 67                	ja     8010237e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102317:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010231e:	00 
8010231f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102326:	00 
80102327:	89 1c 24             	mov    %ebx,(%esp)
8010232a:	e8 a1 20 00 00       	call   801043d0 <memset>

  if(kmem.use_lock)
8010232f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102335:	85 d2                	test   %edx,%edx
80102337:	75 37                	jne    80102370 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102339:	a1 78 26 11 80       	mov    0x80112678,%eax
8010233e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102340:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102345:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010234b:	85 c0                	test   %eax,%eax
8010234d:	75 09                	jne    80102358 <kfree+0x68>
    release(&kmem.lock);
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
80102354:	c3                   	ret    
80102355:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102358:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102364:	e9 17 20 00 00       	jmp    80104380 <release>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102370:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102377:	e8 94 1f 00 00       	call   80104310 <acquire>
8010237c:	eb bb                	jmp    80102339 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010237e:	c7 04 24 86 6f 10 80 	movl   $0x80106f86,(%esp)
80102385:	e8 d6 df ff ff       	call   80100360 <panic>
8010238a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102390 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	56                   	push   %esi
80102394:	53                   	push   %ebx
80102395:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102398:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010239b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010239e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023aa:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023b0:	39 de                	cmp    %ebx,%esi
801023b2:	73 08                	jae    801023bc <freerange+0x2c>
801023b4:	eb 18                	jmp    801023ce <freerange+0x3e>
801023b6:	66 90                	xchg   %ax,%ax
801023b8:	89 da                	mov    %ebx,%edx
801023ba:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023bc:	89 14 24             	mov    %edx,(%esp)
801023bf:	e8 2c ff ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ca:	39 f0                	cmp    %esi,%eax
801023cc:	76 ea                	jbe    801023b8 <freerange+0x28>
    kfree(p);
}
801023ce:	83 c4 10             	add    $0x10,%esp
801023d1:	5b                   	pop    %ebx
801023d2:	5e                   	pop    %esi
801023d3:	5d                   	pop    %ebp
801023d4:	c3                   	ret    
801023d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023e0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
801023e5:	83 ec 10             	sub    $0x10,%esp
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023eb:	c7 44 24 04 8c 6f 10 	movl   $0x80106f8c,0x4(%esp)
801023f2:	80 
801023f3:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023fa:	e8 a1 1d 00 00       	call   801041a0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ff:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102402:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102409:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010240c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102412:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102418:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010241e:	39 de                	cmp    %ebx,%esi
80102420:	73 0a                	jae    8010242c <kinit1+0x4c>
80102422:	eb 1a                	jmp    8010243e <kinit1+0x5e>
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102428:	89 da                	mov    %ebx,%edx
8010242a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010242c:	89 14 24             	mov    %edx,(%esp)
8010242f:	e8 bc fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102434:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010243a:	39 c6                	cmp    %eax,%esi
8010243c:	73 ea                	jae    80102428 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	5b                   	pop    %ebx
80102442:	5e                   	pop    %esi
80102443:	5d                   	pop    %ebp
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
80102455:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102458:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010245b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010245e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102464:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 08                	jae    8010247c <kinit2+0x2c>
80102474:	eb 18                	jmp    8010248e <kinit2+0x3e>
80102476:	66 90                	xchg   %ax,%ax
80102478:	89 da                	mov    %ebx,%edx
8010247a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010247c:	89 14 24             	mov    %edx,(%esp)
8010247f:	e8 6c fe ff ff       	call   801022f0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102484:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010248a:	39 c6                	cmp    %eax,%esi
8010248c:	73 ea                	jae    80102478 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010248e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102495:	00 00 00 
}
80102498:	83 c4 10             	add    $0x10,%esp
8010249b:	5b                   	pop    %ebx
8010249c:	5e                   	pop    %esi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    
8010249f:	90                   	nop

801024a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024a7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	75 30                	jne    801024e0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024b0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024b6:	85 db                	test   %ebx,%ebx
801024b8:	74 08                	je     801024c2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ba:	8b 13                	mov    (%ebx),%edx
801024bc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024c2:	85 c0                	test   %eax,%eax
801024c4:	74 0c                	je     801024d2 <kalloc+0x32>
    release(&kmem.lock);
801024c6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024cd:	e8 ae 1e 00 00       	call   80104380 <release>
  return (char*)r;
}
801024d2:	83 c4 14             	add    $0x14,%esp
801024d5:	89 d8                	mov    %ebx,%eax
801024d7:	5b                   	pop    %ebx
801024d8:	5d                   	pop    %ebp
801024d9:	c3                   	ret    
801024da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024e0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024e7:	e8 24 1e 00 00       	call   80104310 <acquire>
801024ec:	a1 74 26 11 80       	mov    0x80112674,%eax
801024f1:	eb bd                	jmp    801024b0 <kalloc+0x10>
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102500:	ba 64 00 00 00       	mov    $0x64,%edx
80102505:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102506:	a8 01                	test   $0x1,%al
80102508:	0f 84 ba 00 00 00    	je     801025c8 <kbdgetc+0xc8>
8010250e:	b2 60                	mov    $0x60,%dl
80102510:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102511:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102514:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010251a:	0f 84 88 00 00 00    	je     801025a8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102520:	84 c0                	test   %al,%al
80102522:	79 2c                	jns    80102550 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102524:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010252a:	f6 c2 40             	test   $0x40,%dl
8010252d:	75 05                	jne    80102534 <kbdgetc+0x34>
8010252f:	89 c1                	mov    %eax,%ecx
80102531:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102534:	0f b6 81 c0 70 10 80 	movzbl -0x7fef8f40(%ecx),%eax
8010253b:	83 c8 40             	or     $0x40,%eax
8010253e:	0f b6 c0             	movzbl %al,%eax
80102541:	f7 d0                	not    %eax
80102543:	21 d0                	and    %edx,%eax
80102545:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010254a:	31 c0                	xor    %eax,%eax
8010254c:	c3                   	ret    
8010254d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	53                   	push   %ebx
80102554:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010255a:	f6 c3 40             	test   $0x40,%bl
8010255d:	74 09                	je     80102568 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010255f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102562:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102565:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102568:	0f b6 91 c0 70 10 80 	movzbl -0x7fef8f40(%ecx),%edx
  shift ^= togglecode[data];
8010256f:	0f b6 81 c0 6f 10 80 	movzbl -0x7fef9040(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102576:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102578:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010257a:	89 d0                	mov    %edx,%eax
8010257c:	83 e0 03             	and    $0x3,%eax
8010257f:	8b 04 85 a0 6f 10 80 	mov    -0x7fef9060(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102586:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010258c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010258f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102593:	74 0b                	je     801025a0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102595:	8d 50 9f             	lea    -0x61(%eax),%edx
80102598:	83 fa 19             	cmp    $0x19,%edx
8010259b:	77 1b                	ja     801025b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010259d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a0:	5b                   	pop    %ebx
801025a1:	5d                   	pop    %ebp
801025a2:	c3                   	ret    
801025a3:	90                   	nop
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025a8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025af:	31 c0                	xor    %eax,%eax
801025b1:	c3                   	ret    
801025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025bb:	8d 50 20             	lea    0x20(%eax),%edx
801025be:	83 f9 19             	cmp    $0x19,%ecx
801025c1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025c4:	eb da                	jmp    801025a0 <kbdgetc+0xa0>
801025c6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax

801025d0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025d6:	c7 04 24 00 25 10 80 	movl   $0x80102500,(%esp)
801025dd:	e8 ce e1 ff ff       	call   801007b0 <consoleintr>
}
801025e2:	c9                   	leave  
801025e3:	c3                   	ret    
801025e4:	66 90                	xchg   %ax,%ax
801025e6:	66 90                	xchg   %ax,%ax
801025e8:	66 90                	xchg   %ax,%ax
801025ea:	66 90                	xchg   %ax,%ax
801025ec:	66 90                	xchg   %ax,%ax
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
801025f0:	55                   	push   %ebp
801025f1:	89 c1                	mov    %eax,%ecx
801025f3:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f5:	ba 70 00 00 00       	mov    $0x70,%edx
801025fa:	53                   	push   %ebx
801025fb:	31 c0                	xor    %eax,%eax
801025fd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025fe:	bb 71 00 00 00       	mov    $0x71,%ebx
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102606:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 01                	mov    %eax,(%ecx)
8010260d:	b8 02 00 00 00       	mov    $0x2,%eax
80102612:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
80102616:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 41 04             	mov    %eax,0x4(%ecx)
8010261e:	b8 04 00 00 00       	mov    $0x4,%eax
80102623:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102624:	89 da                	mov    %ebx,%edx
80102626:	ec                   	in     (%dx),%al
80102627:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262a:	b2 70                	mov    $0x70,%dl
8010262c:	89 41 08             	mov    %eax,0x8(%ecx)
8010262f:	b8 07 00 00 00       	mov    $0x7,%eax
80102634:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102635:	89 da                	mov    %ebx,%edx
80102637:	ec                   	in     (%dx),%al
80102638:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263b:	b2 70                	mov    $0x70,%dl
8010263d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102640:	b8 08 00 00 00       	mov    $0x8,%eax
80102645:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102646:	89 da                	mov    %ebx,%edx
80102648:	ec                   	in     (%dx),%al
80102649:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264c:	b2 70                	mov    $0x70,%dl
8010264e:	89 41 10             	mov    %eax,0x10(%ecx)
80102651:	b8 09 00 00 00       	mov    $0x9,%eax
80102656:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102657:	89 da                	mov    %ebx,%edx
80102659:	ec                   	in     (%dx),%al
8010265a:	0f b6 d8             	movzbl %al,%ebx
8010265d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102660:	5b                   	pop    %ebx
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    
80102663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102670:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c0 00 00 00    	je     80102740 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026b1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026be:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 6f                	ja     80102748 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fd:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102728:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010272e:	80 e6 10             	and    $0x10,%dh
80102731:	75 f5                	jne    80102728 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102733:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010273a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102740:	5d                   	pop    %ebp
80102741:	c3                   	ret    
80102742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102748:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010274f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102752:	8b 50 20             	mov    0x20(%eax),%edx
80102755:	eb 82                	jmp    801026d9 <lapicinit+0x69>
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102760:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0c                	je     80102778 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010276c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010276f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102770:	c1 e8 18             	shr    $0x18,%eax
}
80102773:	c3                   	ret    
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102778:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010277a:	5d                   	pop    %ebp
8010277b:	c3                   	ret    
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102780:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102793:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	90                   	nop
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
}
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027b0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b1:	ba 70 00 00 00       	mov    $0x70,%edx
801027b6:	89 e5                	mov    %esp,%ebp
801027b8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027bd:	53                   	push   %ebx
801027be:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027c4:	ee                   	out    %al,(%dx)
801027c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ca:	b2 71                	mov    $0x71,%dl
801027cc:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027cd:	31 c0                	xor    %eax,%eax
801027cf:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027d5:	89 d8                	mov    %ebx,%eax
801027d7:	c1 e8 04             	shr    $0x4,%eax
801027da:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027e5:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027e8:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027eb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027fb:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102801:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102808:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280b:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102817:	89 da                	mov    %ebx,%edx
80102819:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102822:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102825:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102837:	5b                   	pop    %ebx
80102838:	5d                   	pop    %ebp
80102839:	c3                   	ret    
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102840 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102840:	55                   	push   %ebp
80102841:	ba 70 00 00 00       	mov    $0x70,%edx
80102846:	89 e5                	mov    %esp,%ebp
80102848:	b8 0b 00 00 00       	mov    $0xb,%eax
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 4c             	sub    $0x4c,%esp
80102853:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102854:	b2 71                	mov    $0x71,%dl
80102856:	ec                   	in     (%dx),%al
80102857:	88 45 b7             	mov    %al,-0x49(%ebp)
8010285a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010285d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102861:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102868:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010286d:	89 d8                	mov    %ebx,%eax
8010286f:	e8 7c fd ff ff       	call   801025f0 <fill_rtcdate>
80102874:	b8 0a 00 00 00       	mov    $0xa,%eax
80102879:	89 f2                	mov    %esi,%edx
8010287b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	ba 71 00 00 00       	mov    $0x71,%edx
80102881:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102882:	84 c0                	test   %al,%al
80102884:	78 e7                	js     8010286d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102886:	89 f8                	mov    %edi,%eax
80102888:	e8 63 fd ff ff       	call   801025f0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010288d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102894:	00 
80102895:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102899:	89 1c 24             	mov    %ebx,(%esp)
8010289c:	e8 7f 1b 00 00       	call   80104420 <memcmp>
801028a1:	85 c0                	test   %eax,%eax
801028a3:	75 c3                	jne    80102868 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028a5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028a9:	75 78                	jne    80102923 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ae:	89 c2                	mov    %eax,%edx
801028b0:	83 e0 0f             	and    $0xf,%eax
801028b3:	c1 ea 04             	shr    $0x4,%edx
801028b6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028b9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028bc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028c2:	89 c2                	mov    %eax,%edx
801028c4:	83 e0 0f             	and    $0xf,%eax
801028c7:	c1 ea 04             	shr    $0x4,%edx
801028ca:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028cd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028d6:	89 c2                	mov    %eax,%edx
801028d8:	83 e0 0f             	and    $0xf,%eax
801028db:	c1 ea 04             	shr    $0x4,%edx
801028de:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028ea:	89 c2                	mov    %eax,%edx
801028ec:	83 e0 0f             	and    $0xf,%eax
801028ef:	c1 ea 04             	shr    $0x4,%edx
801028f2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028fe:	89 c2                	mov    %eax,%edx
80102900:	83 e0 0f             	and    $0xf,%eax
80102903:	c1 ea 04             	shr    $0x4,%edx
80102906:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102909:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010290f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102912:	89 c2                	mov    %eax,%edx
80102914:	83 e0 0f             	and    $0xf,%eax
80102917:	c1 ea 04             	shr    $0x4,%edx
8010291a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102920:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102923:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102926:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102929:	89 01                	mov    %eax,(%ecx)
8010292b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010292e:	89 41 04             	mov    %eax,0x4(%ecx)
80102931:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102934:	89 41 08             	mov    %eax,0x8(%ecx)
80102937:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010293a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010293d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102940:	89 41 10             	mov    %eax,0x10(%ecx)
80102943:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102946:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102949:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102950:	83 c4 4c             	add    $0x4c,%esp
80102953:	5b                   	pop    %ebx
80102954:	5e                   	pop    %esi
80102955:	5f                   	pop    %edi
80102956:	5d                   	pop    %ebp
80102957:	c3                   	ret    
80102958:	66 90                	xchg   %ax,%ax
8010295a:	66 90                	xchg   %ax,%ax
8010295c:	66 90                	xchg   %ax,%ax
8010295e:	66 90                	xchg   %ax,%ax

80102960 <install_trans>:


// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	56                   	push   %esi
80102964:	53                   	push   %ebx
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }*/
 
  for (tail = 0; tail < log.lh.n; tail++) {
80102965:	31 db                	xor    %ebx,%ebx


// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102967:	83 ec 10             	sub    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }*/
 
  for (tail = 0; tail < log.lh.n; tail++) {
8010296a:	a1 c8 26 11 80       	mov    0x801126c8,%eax
8010296f:	85 c0                	test   %eax,%eax
80102971:	7e 3a                	jle    801029ad <install_trans+0x4d>
80102973:	90                   	nop
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
   // struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102978:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }*/
 
  for (tail = 0; tail < log.lh.n; tail++) {
8010297f:	83 c3 01             	add    $0x1,%ebx
   // struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102982:	89 44 24 04          	mov    %eax,0x4(%esp)
80102986:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010298b:	89 04 24             	mov    %eax,(%esp)
8010298e:	e8 3d d7 ff ff       	call   801000d0 <bread>
80102993:	89 c6                	mov    %eax,%esi
   // memmove(dbuf->data, to->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
80102995:	89 04 24             	mov    %eax,(%esp)
80102998:	e8 03 d8 ff ff       	call   801001a0 <bwrite>
   // brelse(lbuf);
    brelse(dbuf);
8010299d:	89 34 24             	mov    %esi,(%esp)
801029a0:	e8 3b d8 ff ff       	call   801001e0 <brelse>
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }*/
 
  for (tail = 0; tail < log.lh.n; tail++) {
801029a5:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029ab:	7f cb                	jg     80102978 <install_trans+0x18>
    bwrite(dbuf);  // write dst to disk
   // brelse(lbuf);
    brelse(dbuf);
  }
 
}
801029ad:	83 c4 10             	add    $0x10,%esp
801029b0:	5b                   	pop    %ebx
801029b1:	5e                   	pop    %esi
801029b2:	5d                   	pop    %ebp
801029b3:	c3                   	ret    
801029b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801029c0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
801029c3:	57                   	push   %edi
801029c4:	56                   	push   %esi
801029c5:	53                   	push   %ebx
801029c6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
801029c9:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d2:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029d7:	89 04 24             	mov    %eax,(%esp)
801029da:	e8 f1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801029df:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
801029e5:	31 d2                	xor    %edx,%edx
801029e7:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
801029e9:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801029eb:	89 58 5c             	mov    %ebx,0x5c(%eax)
801029ee:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
801029f1:	7e 17                	jle    80102a0a <write_head+0x4a>
801029f3:	90                   	nop
801029f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
801029f8:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
801029ff:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a03:	83 c2 01             	add    $0x1,%edx
80102a06:	39 da                	cmp    %ebx,%edx
80102a08:	75 ee                	jne    801029f8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a0a:	89 3c 24             	mov    %edi,(%esp)
80102a0d:	e8 8e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a12:	89 3c 24             	mov    %edi,(%esp)
80102a15:	e8 c6 d7 ff ff       	call   801001e0 <brelse>
}
80102a1a:	83 c4 1c             	add    $0x1c,%esp
80102a1d:	5b                   	pop    %ebx
80102a1e:	5e                   	pop    %esi
80102a1f:	5f                   	pop    %edi
80102a20:	5d                   	pop    %ebp
80102a21:	c3                   	ret    
80102a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a30 <checkpoint>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)

void
checkpoint (void){
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	83 ec 18             	sub    $0x18,%esp
	while(1) {
		acquire( &log.lock);
80102a36:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a3d:	e8 ce 18 00 00       	call   80104310 <acquire>
		while (log.committing == 0 || log.lh.n == 0)
80102a42:	eb 18                	jmp    80102a5c <checkpoint+0x2c>
80102a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		{
			sleep(&trans, &log.lock);
80102a48:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102a4f:	80 
80102a50:	c7 04 24 44 27 11 80 	movl   $0x80112744,(%esp)
80102a57:	e8 a4 12 00 00       	call   80103d00 <sleep>

void
checkpoint (void){
	while(1) {
		acquire( &log.lock);
		while (log.committing == 0 || log.lh.n == 0)
80102a5c:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
80102a62:	85 d2                	test   %edx,%edx
80102a64:	74 e2                	je     80102a48 <checkpoint+0x18>
80102a66:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102a6b:	85 c0                	test   %eax,%eax
80102a6d:	74 d9                	je     80102a48 <checkpoint+0x18>
		{
			sleep(&trans, &log.lock);
		}
		release (&log.lock);
80102a6f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a76:	e8 05 19 00 00       	call   80104380 <release>
	
		install_trans();
80102a7b:	e8 e0 fe ff ff       	call   80102960 <install_trans>
		log.lh.n = 0;
80102a80:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102a87:	00 00 00 
		write_head();
80102a8a:	e8 31 ff ff ff       	call   801029c0 <write_head>

		acquire(&log.lock);
80102a8f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a96:	e8 75 18 00 00       	call   80104310 <acquire>
		log.committing = 0;
		wakeup(&log);
80102a9b:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
		install_trans();
		log.lh.n = 0;
		write_head();

		acquire(&log.lock);
		log.committing = 0;
80102aa2:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102aa9:	00 00 00 
		wakeup(&log);
80102aac:	e8 df 13 00 00       	call   80103e90 <wakeup>
		release(&log.lock);
80102ab1:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ab8:	e8 c3 18 00 00       	call   80104380 <release>
	}
80102abd:	e9 74 ff ff ff       	jmp    80102a36 <checkpoint+0x6>
80102ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ad0 <checkpointproc>:
}
//PAGEBREAK: 32
// Set up first user process.
void
checkpointproc(void)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	53                   	push   %ebx
80102ad4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p = allocproc();
80102ad7:	e8 24 0c 00 00       	call   80103700 <allocproc>

  memset(p->tf, 0, sizeof(*p->tf));
80102adc:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80102ae3:	00 
80102ae4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102aeb:	00 
//PAGEBREAK: 32
// Set up first user process.
void
checkpointproc(void)
{
  struct proc *p = allocproc();
80102aec:	89 c3                	mov    %eax,%ebx

  memset(p->tf, 0, sizeof(*p->tf));
80102aee:	8b 40 18             	mov    0x18(%eax),%eax
80102af1:	89 04 24             	mov    %eax,(%esp)
80102af4:	e8 d7 18 00 00       	call   801043d0 <memset>
  p->tf->eip = (uint)checkpoint;
80102af9:	8b 43 18             	mov    0x18(%ebx),%eax
80102afc:	c7 40 38 30 2a 10 80 	movl   $0x80102a30,0x38(%eax)
  
  p->pgdir = setupkvm();
80102b03:	e8 68 3f 00 00       	call   80106a70 <setupkvm>
  p->sz = PGSIZE;
  p->tf->cs = (SEG_KCODE << 3) ;
80102b08:	ba 08 00 00 00       	mov    $0x8,%edx
  p->tf->ds = (SEG_KDATA << 3) ;
80102b0d:	b9 10 00 00 00       	mov    $0x10,%ecx

  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->eip = (uint)checkpoint;
  
  p->pgdir = setupkvm();
  p->sz = PGSIZE;
80102b12:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  struct proc *p = allocproc();

  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->eip = (uint)checkpoint;
  
  p->pgdir = setupkvm();
80102b18:	89 43 04             	mov    %eax,0x4(%ebx)
  p->sz = PGSIZE;
  p->tf->cs = (SEG_KCODE << 3) ;
80102b1b:	8b 43 18             	mov    0x18(%ebx),%eax
80102b1e:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_KDATA << 3) ;
80102b22:	8b 43 18             	mov    0x18(%ebx),%eax
80102b25:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80102b29:	8b 43 18             	mov    0x18(%ebx),%eax
80102b2c:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80102b30:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80102b34:	8b 43 18             	mov    0x18(%ebx),%eax
80102b37:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80102b3b:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80102b3f:	8b 43 18             	mov    0x18(%ebx),%eax
80102b42:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = (uint)p->kstack;
80102b49:	8b 43 18             	mov    0x18(%ebx),%eax
80102b4c:	8b 53 08             	mov    0x8(%ebx),%edx
80102b4f:	89 50 44             	mov    %edx,0x44(%eax)
  
  setproc(p);
80102b52:	89 1c 24             	mov    %ebx,(%esp)
80102b55:	e8 e6 14 00 00       	call   80104040 <setproc>
  acquire(&ptable.lock);
  p->state = RUNNABLE;
  release(&ptable.lock);
  */

}
80102b5a:	83 c4 14             	add    $0x14,%esp
80102b5d:	5b                   	pop    %ebx
80102b5e:	5d                   	pop    %ebp
80102b5f:	c3                   	ret    

80102b60 <initlog>:
void checkpointproc(void);
extern void checkpoint (void);

void
initlog(int dev)
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	56                   	push   %esi
80102b64:	53                   	push   %ebx
80102b65:	83 ec 30             	sub    $0x30,%esp
80102b68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b6b:	c7 44 24 04 c0 71 10 	movl   $0x801071c0,0x4(%esp)
80102b72:	80 
80102b73:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b7a:	e8 21 16 00 00       	call   801041a0 <initlock>
  readsb(dev, &sb);
80102b7f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b82:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b86:	89 1c 24             	mov    %ebx,(%esp)
80102b89:	e8 92 e8 ff ff       	call   80101420 <readsb>
  log.start = sb.logstart;
80102b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b91:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b94:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b97:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b9d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ba1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ba7:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102bac:	e8 1f d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102bb1:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102bb3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102bb6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102bb9:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102bbb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102bc1:	7e 17                	jle    80102bda <initlog+0x7a>
80102bc3:	90                   	nop
80102bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102bc8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102bcc:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102bd3:	83 c2 01             	add    $0x1,%edx
80102bd6:	39 da                	cmp    %ebx,%edx
80102bd8:	75 ee                	jne    80102bc8 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102bda:	89 04 24             	mov    %eax,(%esp)
80102bdd:	e8 fe d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102be2:	e8 79 fd ff ff       	call   80102960 <install_trans>
  log.lh.n = 0;
80102be7:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102bee:	00 00 00 
  write_head(); // clear the log
80102bf1:	e8 ca fd ff ff       	call   801029c0 <write_head>
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();

  log.committing = 0;
80102bf6:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102bfd:	00 00 00 
  checkpointproc();  
80102c00:	e8 cb fe ff ff       	call   80102ad0 <checkpointproc>
 
}
80102c05:	83 c4 30             	add    $0x30,%esp
80102c08:	5b                   	pop    %ebx
80102c09:	5e                   	pop    %esi
80102c0a:	5d                   	pop    %ebp
80102c0b:	c3                   	ret    
80102c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102c16:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c1d:	e8 ee 16 00 00       	call   80104310 <acquire>
80102c22:	eb 18                	jmp    80102c3c <begin_op+0x2c>
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
	  //wakeup(&trans);
      sleep(&log, &log.lock);
80102c28:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102c2f:	80 
80102c30:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c37:	e8 c4 10 00 00       	call   80103d00 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102c3c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102c41:	85 c0                	test   %eax,%eax
80102c43:	75 e3                	jne    80102c28 <begin_op+0x18>
	  //wakeup(&trans);
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c45:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c4a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c50:	83 c0 01             	add    $0x1,%eax
80102c53:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c56:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c59:	83 fa 1e             	cmp    $0x1e,%edx
80102c5c:	7f ca                	jg     80102c28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c5e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c65:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c6a:	e8 11 17 00 00       	call   80104380 <release>
      break;
    }
  }
}
80102c6f:	c9                   	leave  
80102c70:	c3                   	ret    
80102c71:	eb 0d                	jmp    80102c80 <end_op>
80102c73:	90                   	nop
80102c74:	90                   	nop
80102c75:	90                   	nop
80102c76:	90                   	nop
80102c77:	90                   	nop
80102c78:	90                   	nop
80102c79:	90                   	nop
80102c7a:	90                   	nop
80102c7b:	90                   	nop
80102c7c:	90                   	nop
80102c7d:	90                   	nop
80102c7e:	90                   	nop
80102c7f:	90                   	nop

80102c80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	57                   	push   %edi
80102c84:	56                   	push   %esi
80102c85:	53                   	push   %ebx
80102c86:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c89:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c90:	e8 7b 16 00 00       	call   80104310 <acquire>
  log.outstanding -= 1;
80102c95:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c9a:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102ca0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102ca3:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102ca5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102caa:	0f 85 eb 00 00 00    	jne    80102d9b <end_op+0x11b>
    panic("log.committing");
  if(log.outstanding == 0){
80102cb0:	85 c0                	test   %eax,%eax
80102cb2:	0f 85 c3 00 00 00    	jne    80102d7b <end_op+0xfb>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102cb8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
	if (log.lh.n > 0) {
80102cbf:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102cc1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102cc8:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ccb:	e8 b0 16 00 00       	call   80104380 <release>
}

static void
commit()
{
	if (log.lh.n > 0) {
80102cd0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102cd5:	85 c0                	test   %eax,%eax
80102cd7:	0f 8e 88 00 00 00    	jle    80102d65 <end_op+0xe5>
80102cdd:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ce0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102ce5:	01 d8                	add    %ebx,%eax
80102ce7:	83 c0 01             	add    $0x1,%eax
80102cea:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cee:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102cf3:	89 04 24             	mov    %eax,(%esp)
80102cf6:	e8 d5 d3 ff ff       	call   801000d0 <bread>
80102cfb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cfd:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d04:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d07:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d0b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102d10:	89 04 24             	mov    %eax,(%esp)
80102d13:	e8 b8 d3 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102d18:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102d1f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d20:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d22:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d25:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d29:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d2c:	89 04 24             	mov    %eax,(%esp)
80102d2f:	e8 3c 17 00 00       	call   80104470 <memmove>
    bwrite(to);  // write the log
80102d34:	89 34 24             	mov    %esi,(%esp)
80102d37:	e8 64 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d3c:	89 3c 24             	mov    %edi,(%esp)
80102d3f:	e8 9c d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d44:	89 34 24             	mov    %esi,(%esp)
80102d47:	e8 94 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d4c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102d52:	7c 8c                	jl     80102ce0 <end_op+0x60>
static void
commit()
{
	if (log.lh.n > 0) {
		write_log();     // Write modified blocks from cache to log
		write_head();    // Write header to disk -- the real commit
80102d54:	e8 67 fc ff ff       	call   801029c0 <write_head>

		wakeup(&trans);
80102d59:	c7 04 24 44 27 11 80 	movl   $0x80112744,(%esp)
80102d60:	e8 2b 11 00 00       	call   80103e90 <wakeup>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();

 
 	acquire(&log.lock);
80102d65:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d6c:	e8 9f 15 00 00       	call   80104310 <acquire>
    log.committing = 0;
80102d71:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d78:	00 00 00 
    wakeup(&log);
80102d7b:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d82:	e8 09 11 00 00       	call   80103e90 <wakeup>
    release(&log.lock);
80102d87:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d8e:	e8 ed 15 00 00       	call   80104380 <release>
	
  }
}
80102d93:	83 c4 1c             	add    $0x1c,%esp
80102d96:	5b                   	pop    %ebx
80102d97:	5e                   	pop    %esi
80102d98:	5f                   	pop    %edi
80102d99:	5d                   	pop    %ebp
80102d9a:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d9b:	c7 04 24 c4 71 10 80 	movl   $0x801071c4,(%esp)
80102da2:	e8 b9 d5 ff ff       	call   80100360 <panic>
80102da7:	89 f6                	mov    %esi,%esi
80102da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102db0 <log_write>:
		release(&log.lock);
	}
}
void
log_write(struct buf *b)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
		release(&log.lock);
	}
}
void
log_write(struct buf *b)
{
80102dbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dbf:	83 f8 1d             	cmp    $0x1d,%eax
80102dc2:	0f 8f 98 00 00 00    	jg     80102e60 <log_write+0xb0>
80102dc8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102dce:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102dd1:	39 d0                	cmp    %edx,%eax
80102dd3:	0f 8d 87 00 00 00    	jge    80102e60 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dd9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102dde:	85 c0                	test   %eax,%eax
80102de0:	0f 8e 86 00 00 00    	jle    80102e6c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102de6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ded:	e8 1e 15 00 00       	call   80104310 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102df2:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102df8:	83 fa 00             	cmp    $0x0,%edx
80102dfb:	7e 54                	jle    80102e51 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dfd:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e00:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e02:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102e08:	75 0f                	jne    80102e19 <log_write+0x69>
80102e0a:	eb 3c                	jmp    80102e48 <log_write+0x98>
80102e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e10:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102e17:	74 2f                	je     80102e48 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e19:	83 c0 01             	add    $0x1,%eax
80102e1c:	39 d0                	cmp    %edx,%eax
80102e1e:	75 f0                	jne    80102e10 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e20:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e27:	83 c2 01             	add    $0x1,%edx
80102e2a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102e30:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e33:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102e3a:	83 c4 14             	add    $0x14,%esp
80102e3d:	5b                   	pop    %ebx
80102e3e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102e3f:	e9 3c 15 00 00       	jmp    80104380 <release>
80102e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e48:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102e4f:	eb df                	jmp    80102e30 <log_write+0x80>
80102e51:	8b 43 08             	mov    0x8(%ebx),%eax
80102e54:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e59:	75 d5                	jne    80102e30 <log_write+0x80>
80102e5b:	eb ca                	jmp    80102e27 <log_write+0x77>
80102e5d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e60:	c7 04 24 d3 71 10 80 	movl   $0x801071d3,(%esp)
80102e67:	e8 f4 d4 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e6c:	c7 04 24 e9 71 10 80 	movl   $0x801071e9,(%esp)
80102e73:	e8 e8 d4 ff ff       	call   80100360 <panic>
80102e78:	66 90                	xchg   %ax,%ax
80102e7a:	66 90                	xchg   %ax,%ax
80102e7c:	66 90                	xchg   %ax,%ax
80102e7e:	66 90                	xchg   %ax,%ax

80102e80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e87:	e8 24 08 00 00       	call   801036b0 <cpuid>
80102e8c:	89 c3                	mov    %eax,%ebx
80102e8e:	e8 1d 08 00 00       	call   801036b0 <cpuid>
80102e93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102e97:	c7 04 24 04 72 10 80 	movl   $0x80107204,(%esp)
80102e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ea2:	e8 a9 d7 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102ea7:	e8 04 27 00 00       	call   801055b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102eac:	e8 7f 07 00 00       	call   80103630 <mycpu>
80102eb1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eb3:	b8 01 00 00 00       	mov    $0x1,%eax
80102eb8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102ebf:	e8 9c 0b 00 00       	call   80103a60 <scheduler>
80102ec4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102eca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102ed0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ed6:	e8 95 37 00 00       	call   80106670 <switchkvm>
  seginit();
80102edb:	e8 d0 36 00 00       	call   801065b0 <seginit>
  lapicinit();
80102ee0:	e8 8b f7 ff ff       	call   80102670 <lapicinit>
  mpmain();
80102ee5:	e8 96 ff ff ff       	call   80102e80 <mpmain>
80102eea:	66 90                	xchg   %ax,%ax
80102eec:	66 90                	xchg   %ax,%ax
80102eee:	66 90                	xchg   %ax,%ax

80102ef0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102ef4:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102ef9:	83 e4 f0             	and    $0xfffffff0,%esp
80102efc:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eff:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102f06:	80 
80102f07:	c7 04 24 a8 54 11 80 	movl   $0x801154a8,(%esp)
80102f0e:	e8 cd f4 ff ff       	call   801023e0 <kinit1>
  kvmalloc();      // kernel page table
80102f13:	e8 e8 3b 00 00       	call   80106b00 <kvmalloc>
  mpinit();        // detect other processors
80102f18:	e8 73 01 00 00       	call   80103090 <mpinit>
80102f1d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102f20:	e8 4b f7 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102f25:	e8 86 36 00 00       	call   801065b0 <seginit>
  picinit();       // disable pic
80102f2a:	e8 21 03 00 00       	call   80103250 <picinit>
80102f2f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102f30:	e8 cb f2 ff ff       	call   80102200 <ioapicinit>
  consoleinit();   // console hardware
80102f35:	e8 16 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102f3a:	e8 91 29 00 00       	call   801058d0 <uartinit>
80102f3f:	90                   	nop
  pinit();         // process table
80102f40:	e8 cb 06 00 00       	call   80103610 <pinit>
  tvinit();        // trap vectors
80102f45:	e8 c6 25 00 00       	call   80105510 <tvinit>
  binit();         // buffer cache
80102f4a:	e8 f1 d0 ff ff       	call   80100040 <binit>
80102f4f:	90                   	nop
  fileinit();      // file table
80102f50:	e8 fb dd ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102f55:	e8 a6 f0 ff ff       	call   80102000 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f5a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102f61:	00 
80102f62:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102f69:	80 
80102f6a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102f71:	e8 fa 14 00 00       	call   80104470 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f76:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f7d:	00 00 00 
80102f80:	05 80 27 11 80       	add    $0x80112780,%eax
80102f85:	39 d8                	cmp    %ebx,%eax
80102f87:	76 6a                	jbe    80102ff3 <main+0x103>
80102f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f90:	e8 9b 06 00 00       	call   80103630 <mycpu>
80102f95:	39 d8                	cmp    %ebx,%eax
80102f97:	74 41                	je     80102fda <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f99:	e8 02 f5 ff ff       	call   801024a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
80102f9e:	c7 05 f8 6f 00 80 d0 	movl   $0x80102ed0,0x80006ff8
80102fa5:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fa8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102faf:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fb2:	05 00 10 00 00       	add    $0x1000,%eax
80102fb7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102fbc:	0f b6 03             	movzbl (%ebx),%eax
80102fbf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102fc6:	00 
80102fc7:	89 04 24             	mov    %eax,(%esp)
80102fca:	e8 e1 f7 ff ff       	call   801027b0 <lapicstartap>
80102fcf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fd0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	74 f6                	je     80102fd0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102fda:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102fe1:	00 00 00 
80102fe4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fea:	05 80 27 11 80       	add    $0x80112780,%eax
80102fef:	39 c3                	cmp    %eax,%ebx
80102ff1:	72 9d                	jb     80102f90 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ff3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102ffa:	8e 
80102ffb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103002:	e8 49 f4 ff ff       	call   80102450 <kinit2>
  userinit();      // first user process
80103007:	e8 c4 07 00 00       	call   801037d0 <userinit>
  mpmain();        // finish this processor's setup
8010300c:	e8 6f fe ff ff       	call   80102e80 <mpmain>
80103011:	66 90                	xchg   %ax,%ax
80103013:	66 90                	xchg   %ax,%ax
80103015:	66 90                	xchg   %ax,%ax
80103017:	66 90                	xchg   %ax,%ax
80103019:	66 90                	xchg   %ax,%ax
8010301b:	66 90                	xchg   %ax,%ax
8010301d:	66 90                	xchg   %ax,%ax
8010301f:	90                   	nop

80103020 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103024:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010302a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010302b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010302e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103031:	39 de                	cmp    %ebx,%esi
80103033:	73 3c                	jae    80103071 <mpsearch1+0x51>
80103035:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103038:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010303f:	00 
80103040:	c7 44 24 04 18 72 10 	movl   $0x80107218,0x4(%esp)
80103047:	80 
80103048:	89 34 24             	mov    %esi,(%esp)
8010304b:	e8 d0 13 00 00       	call   80104420 <memcmp>
80103050:	85 c0                	test   %eax,%eax
80103052:	75 16                	jne    8010306a <mpsearch1+0x4a>
80103054:	31 c9                	xor    %ecx,%ecx
80103056:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103058:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010305c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010305f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103061:	83 fa 10             	cmp    $0x10,%edx
80103064:	75 f2                	jne    80103058 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103066:	84 c9                	test   %cl,%cl
80103068:	74 10                	je     8010307a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
8010306a:	83 c6 10             	add    $0x10,%esi
8010306d:	39 f3                	cmp    %esi,%ebx
8010306f:	77 c7                	ja     80103038 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103071:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103074:	31 c0                	xor    %eax,%eax
}
80103076:	5b                   	pop    %ebx
80103077:	5e                   	pop    %esi
80103078:	5d                   	pop    %ebp
80103079:	c3                   	ret    
8010307a:	83 c4 10             	add    $0x10,%esp
8010307d:	89 f0                	mov    %esi,%eax
8010307f:	5b                   	pop    %ebx
80103080:	5e                   	pop    %esi
80103081:	5d                   	pop    %ebp
80103082:	c3                   	ret    
80103083:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103090 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103090:	55                   	push   %ebp
80103091:	89 e5                	mov    %esp,%ebp
80103093:	57                   	push   %edi
80103094:	56                   	push   %esi
80103095:	53                   	push   %ebx
80103096:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103099:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030a7:	c1 e0 08             	shl    $0x8,%eax
801030aa:	09 d0                	or     %edx,%eax
801030ac:	c1 e0 04             	shl    $0x4,%eax
801030af:	85 c0                	test   %eax,%eax
801030b1:	75 1b                	jne    801030ce <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030b3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030ba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030c1:	c1 e0 08             	shl    $0x8,%eax
801030c4:	09 d0                	or     %edx,%eax
801030c6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030c9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801030ce:	ba 00 04 00 00       	mov    $0x400,%edx
801030d3:	e8 48 ff ff ff       	call   80103020 <mpsearch1>
801030d8:	85 c0                	test   %eax,%eax
801030da:	89 c7                	mov    %eax,%edi
801030dc:	0f 84 22 01 00 00    	je     80103204 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030e2:	8b 77 04             	mov    0x4(%edi),%esi
801030e5:	85 f6                	test   %esi,%esi
801030e7:	0f 84 30 01 00 00    	je     8010321d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030ed:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801030f3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801030fa:	00 
801030fb:	c7 44 24 04 1d 72 10 	movl   $0x8010721d,0x4(%esp)
80103102:	80 
80103103:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103106:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103109:	e8 12 13 00 00       	call   80104420 <memcmp>
8010310e:	85 c0                	test   %eax,%eax
80103110:	0f 85 07 01 00 00    	jne    8010321d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103116:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010311d:	3c 04                	cmp    $0x4,%al
8010311f:	0f 85 0b 01 00 00    	jne    80103230 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103125:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010312c:	85 c0                	test   %eax,%eax
8010312e:	74 21                	je     80103151 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103130:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103132:	31 d2                	xor    %edx,%edx
80103134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103138:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010313f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103140:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103143:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103145:	39 d0                	cmp    %edx,%eax
80103147:	7f ef                	jg     80103138 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103149:	84 c9                	test   %cl,%cl
8010314b:	0f 85 cc 00 00 00    	jne    8010321d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103154:	85 c0                	test   %eax,%eax
80103156:	0f 84 c1 00 00 00    	je     8010321d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010315c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103162:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103167:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010316c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103173:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103179:	03 55 e4             	add    -0x1c(%ebp),%edx
8010317c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103180:	39 c2                	cmp    %eax,%edx
80103182:	76 1b                	jbe    8010319f <mpinit+0x10f>
80103184:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103187:	80 f9 04             	cmp    $0x4,%cl
8010318a:	77 74                	ja     80103200 <mpinit+0x170>
8010318c:	ff 24 8d 5c 72 10 80 	jmp    *-0x7fef8da4(,%ecx,4)
80103193:	90                   	nop
80103194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103198:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010319b:	39 c2                	cmp    %eax,%edx
8010319d:	77 e5                	ja     80103184 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010319f:	85 db                	test   %ebx,%ebx
801031a1:	0f 84 93 00 00 00    	je     8010323a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801031a7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801031ab:	74 12                	je     801031bf <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ad:	ba 22 00 00 00       	mov    $0x22,%edx
801031b2:	b8 70 00 00 00       	mov    $0x70,%eax
801031b7:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b8:	b2 23                	mov    $0x23,%dl
801031ba:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031bb:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031be:	ee                   	out    %al,(%dx)
  }
}
801031bf:	83 c4 1c             	add    $0x1c,%esp
801031c2:	5b                   	pop    %ebx
801031c3:	5e                   	pop    %esi
801031c4:	5f                   	pop    %edi
801031c5:	5d                   	pop    %ebp
801031c6:	c3                   	ret    
801031c7:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801031c8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801031ce:	83 fe 07             	cmp    $0x7,%esi
801031d1:	7f 17                	jg     801031ea <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801031d7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801031dd:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031e4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801031ea:	83 c0 14             	add    $0x14,%eax
      continue;
801031ed:	eb 91                	jmp    80103180 <mpinit+0xf0>
801031ef:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031f0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801031f4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031f7:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
801031fd:	eb 81                	jmp    80103180 <mpinit+0xf0>
801031ff:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103200:	31 db                	xor    %ebx,%ebx
80103202:	eb 83                	jmp    80103187 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103204:	ba 00 00 01 00       	mov    $0x10000,%edx
80103209:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010320e:	e8 0d fe ff ff       	call   80103020 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103213:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103215:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103217:	0f 85 c5 fe ff ff    	jne    801030e2 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010321d:	c7 04 24 22 72 10 80 	movl   $0x80107222,(%esp)
80103224:	e8 37 d1 ff ff       	call   80100360 <panic>
80103229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103230:	3c 01                	cmp    $0x1,%al
80103232:	0f 84 ed fe ff ff    	je     80103125 <mpinit+0x95>
80103238:	eb e3                	jmp    8010321d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
8010323a:	c7 04 24 3c 72 10 80 	movl   $0x8010723c,(%esp)
80103241:	e8 1a d1 ff ff       	call   80100360 <panic>
80103246:	66 90                	xchg   %ax,%ax
80103248:	66 90                	xchg   %ax,%ax
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103250:	55                   	push   %ebp
80103251:	ba 21 00 00 00       	mov    $0x21,%edx
80103256:	89 e5                	mov    %esp,%ebp
80103258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010325d:	ee                   	out    %al,(%dx)
8010325e:	b2 a1                	mov    $0xa1,%dl
80103260:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103261:	5d                   	pop    %ebp
80103262:	c3                   	ret    
80103263:	66 90                	xchg   %ax,%ax
80103265:	66 90                	xchg   %ax,%ax
80103267:	66 90                	xchg   %ax,%ax
80103269:	66 90                	xchg   %ax,%ax
8010326b:	66 90                	xchg   %ax,%ax
8010326d:	66 90                	xchg   %ax,%ax
8010326f:	90                   	nop

80103270 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 1c             	sub    $0x1c,%esp
80103279:	8b 75 08             	mov    0x8(%ebp),%esi
8010327c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010327f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103285:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010328b:	e8 e0 da ff ff       	call   80100d70 <filealloc>
80103290:	85 c0                	test   %eax,%eax
80103292:	89 06                	mov    %eax,(%esi)
80103294:	0f 84 a4 00 00 00    	je     8010333e <pipealloc+0xce>
8010329a:	e8 d1 da ff ff       	call   80100d70 <filealloc>
8010329f:	85 c0                	test   %eax,%eax
801032a1:	89 03                	mov    %eax,(%ebx)
801032a3:	0f 84 87 00 00 00    	je     80103330 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032a9:	e8 f2 f1 ff ff       	call   801024a0 <kalloc>
801032ae:	85 c0                	test   %eax,%eax
801032b0:	89 c7                	mov    %eax,%edi
801032b2:	74 7c                	je     80103330 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801032b4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032bb:	00 00 00 
  p->writeopen = 1;
801032be:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032c5:	00 00 00 
  p->nwrite = 0;
801032c8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032cf:	00 00 00 
  p->nread = 0;
801032d2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801032d9:	00 00 00 
  initlock(&p->lock, "pipe");
801032dc:	89 04 24             	mov    %eax,(%esp)
801032df:	c7 44 24 04 70 72 10 	movl   $0x80107270,0x4(%esp)
801032e6:	80 
801032e7:	e8 b4 0e 00 00       	call   801041a0 <initlock>
  (*f0)->type = FD_PIPE;
801032ec:	8b 06                	mov    (%esi),%eax
801032ee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801032f4:	8b 06                	mov    (%esi),%eax
801032f6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801032fa:	8b 06                	mov    (%esi),%eax
801032fc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103300:	8b 06                	mov    (%esi),%eax
80103302:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103305:	8b 03                	mov    (%ebx),%eax
80103307:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010330d:	8b 03                	mov    (%ebx),%eax
8010330f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103313:	8b 03                	mov    (%ebx),%eax
80103315:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103319:	8b 03                	mov    (%ebx),%eax
  return 0;
8010331b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010331d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103320:	83 c4 1c             	add    $0x1c,%esp
80103323:	89 d8                	mov    %ebx,%eax
80103325:	5b                   	pop    %ebx
80103326:	5e                   	pop    %esi
80103327:	5f                   	pop    %edi
80103328:	5d                   	pop    %ebp
80103329:	c3                   	ret    
8010332a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103330:	8b 06                	mov    (%esi),%eax
80103332:	85 c0                	test   %eax,%eax
80103334:	74 08                	je     8010333e <pipealloc+0xce>
    fileclose(*f0);
80103336:	89 04 24             	mov    %eax,(%esp)
80103339:	e8 f2 da ff ff       	call   80100e30 <fileclose>
  if(*f1)
8010333e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103340:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103345:	85 c0                	test   %eax,%eax
80103347:	74 d7                	je     80103320 <pipealloc+0xb0>
    fileclose(*f1);
80103349:	89 04 24             	mov    %eax,(%esp)
8010334c:	e8 df da ff ff       	call   80100e30 <fileclose>
  return -1;
}
80103351:	83 c4 1c             	add    $0x1c,%esp
80103354:	89 d8                	mov    %ebx,%eax
80103356:	5b                   	pop    %ebx
80103357:	5e                   	pop    %esi
80103358:	5f                   	pop    %edi
80103359:	5d                   	pop    %ebp
8010335a:	c3                   	ret    
8010335b:	90                   	nop
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103360 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	56                   	push   %esi
80103364:	53                   	push   %ebx
80103365:	83 ec 10             	sub    $0x10,%esp
80103368:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010336b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010336e:	89 1c 24             	mov    %ebx,(%esp)
80103371:	e8 9a 0f 00 00       	call   80104310 <acquire>
  if(writable){
80103376:	85 f6                	test   %esi,%esi
80103378:	74 3e                	je     801033b8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010337a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103380:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103387:	00 00 00 
    wakeup(&p->nread);
8010338a:	89 04 24             	mov    %eax,(%esp)
8010338d:	e8 fe 0a 00 00       	call   80103e90 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103392:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103398:	85 d2                	test   %edx,%edx
8010339a:	75 0a                	jne    801033a6 <pipeclose+0x46>
8010339c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033a2:	85 c0                	test   %eax,%eax
801033a4:	74 32                	je     801033d8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033a9:	83 c4 10             	add    $0x10,%esp
801033ac:	5b                   	pop    %ebx
801033ad:	5e                   	pop    %esi
801033ae:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033af:	e9 cc 0f 00 00       	jmp    80104380 <release>
801033b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801033b8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801033be:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033c5:	00 00 00 
    wakeup(&p->nwrite);
801033c8:	89 04 24             	mov    %eax,(%esp)
801033cb:	e8 c0 0a 00 00       	call   80103e90 <wakeup>
801033d0:	eb c0                	jmp    80103392 <pipeclose+0x32>
801033d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801033d8:	89 1c 24             	mov    %ebx,(%esp)
801033db:	e8 a0 0f 00 00       	call   80104380 <release>
    kfree((char*)p);
801033e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
801033e3:	83 c4 10             	add    $0x10,%esp
801033e6:	5b                   	pop    %ebx
801033e7:	5e                   	pop    %esi
801033e8:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801033e9:	e9 02 ef ff ff       	jmp    801022f0 <kfree>
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 1c             	sub    $0x1c,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033fc:	89 1c 24             	mov    %ebx,(%esp)
801033ff:	e8 0c 0f 00 00       	call   80104310 <acquire>
  for(i = 0; i < n; i++){
80103404:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103407:	85 c9                	test   %ecx,%ecx
80103409:	0f 8e b2 00 00 00    	jle    801034c1 <pipewrite+0xd1>
8010340f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103412:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103418:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010341e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103424:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103427:	03 4d 10             	add    0x10(%ebp),%ecx
8010342a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010342d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103433:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103439:	39 c8                	cmp    %ecx,%eax
8010343b:	74 38                	je     80103475 <pipewrite+0x85>
8010343d:	eb 55                	jmp    80103494 <pipewrite+0xa4>
8010343f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103440:	e8 8b 02 00 00       	call   801036d0 <myproc>
80103445:	8b 40 24             	mov    0x24(%eax),%eax
80103448:	85 c0                	test   %eax,%eax
8010344a:	75 33                	jne    8010347f <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010344c:	89 3c 24             	mov    %edi,(%esp)
8010344f:	e8 3c 0a 00 00       	call   80103e90 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103454:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103458:	89 34 24             	mov    %esi,(%esp)
8010345b:	e8 a0 08 00 00       	call   80103d00 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103460:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103466:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010346c:	05 00 02 00 00       	add    $0x200,%eax
80103471:	39 c2                	cmp    %eax,%edx
80103473:	75 23                	jne    80103498 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103475:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010347b:	85 d2                	test   %edx,%edx
8010347d:	75 c1                	jne    80103440 <pipewrite+0x50>
        release(&p->lock);
8010347f:	89 1c 24             	mov    %ebx,(%esp)
80103482:	e8 f9 0e 00 00       	call   80104380 <release>
        return -1;
80103487:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010348c:	83 c4 1c             	add    $0x1c,%esp
8010348f:	5b                   	pop    %ebx
80103490:	5e                   	pop    %esi
80103491:	5f                   	pop    %edi
80103492:	5d                   	pop    %ebp
80103493:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103494:	89 c2                	mov    %eax,%edx
80103496:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103498:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010349b:	8d 42 01             	lea    0x1(%edx),%eax
8010349e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034a4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034aa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801034ae:	0f b6 09             	movzbl (%ecx),%ecx
801034b1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801034b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801034b8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801034bb:	0f 85 6c ff ff ff    	jne    8010342d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034c1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034c7:	89 04 24             	mov    %eax,(%esp)
801034ca:	e8 c1 09 00 00       	call   80103e90 <wakeup>
  release(&p->lock);
801034cf:	89 1c 24             	mov    %ebx,(%esp)
801034d2:	e8 a9 0e 00 00       	call   80104380 <release>
  return n;
801034d7:	8b 45 10             	mov    0x10(%ebp),%eax
801034da:	eb b0                	jmp    8010348c <pipewrite+0x9c>
801034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801034e0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	57                   	push   %edi
801034e4:	56                   	push   %esi
801034e5:	53                   	push   %ebx
801034e6:	83 ec 1c             	sub    $0x1c,%esp
801034e9:	8b 75 08             	mov    0x8(%ebp),%esi
801034ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801034ef:	89 34 24             	mov    %esi,(%esp)
801034f2:	e8 19 0e 00 00       	call   80104310 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034f7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034fd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103503:	75 5b                	jne    80103560 <piperead+0x80>
80103505:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010350b:	85 db                	test   %ebx,%ebx
8010350d:	74 51                	je     80103560 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010350f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103515:	eb 25                	jmp    8010353c <piperead+0x5c>
80103517:	90                   	nop
80103518:	89 74 24 04          	mov    %esi,0x4(%esp)
8010351c:	89 1c 24             	mov    %ebx,(%esp)
8010351f:	e8 dc 07 00 00       	call   80103d00 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103524:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010352a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103530:	75 2e                	jne    80103560 <piperead+0x80>
80103532:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103538:	85 d2                	test   %edx,%edx
8010353a:	74 24                	je     80103560 <piperead+0x80>
    if(myproc()->killed){
8010353c:	e8 8f 01 00 00       	call   801036d0 <myproc>
80103541:	8b 48 24             	mov    0x24(%eax),%ecx
80103544:	85 c9                	test   %ecx,%ecx
80103546:	74 d0                	je     80103518 <piperead+0x38>
      release(&p->lock);
80103548:	89 34 24             	mov    %esi,(%esp)
8010354b:	e8 30 0e 00 00       	call   80104380 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103550:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103553:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103558:	5b                   	pop    %ebx
80103559:	5e                   	pop    %esi
8010355a:	5f                   	pop    %edi
8010355b:	5d                   	pop    %ebp
8010355c:	c3                   	ret    
8010355d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103560:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103563:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103565:	85 d2                	test   %edx,%edx
80103567:	7f 2b                	jg     80103594 <piperead+0xb4>
80103569:	eb 31                	jmp    8010359c <piperead+0xbc>
8010356b:	90                   	nop
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103570:	8d 48 01             	lea    0x1(%eax),%ecx
80103573:	25 ff 01 00 00       	and    $0x1ff,%eax
80103578:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010357e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103583:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103586:	83 c3 01             	add    $0x1,%ebx
80103589:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010358c:	74 0e                	je     8010359c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010358e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103594:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010359a:	75 d4                	jne    80103570 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010359c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035a2:	89 04 24             	mov    %eax,(%esp)
801035a5:	e8 e6 08 00 00       	call   80103e90 <wakeup>
  release(&p->lock);
801035aa:	89 34 24             	mov    %esi,(%esp)
801035ad:	e8 ce 0d 00 00       	call   80104380 <release>
  return i;
}
801035b2:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
801035b5:	89 d8                	mov    %ebx,%eax
}
801035b7:	5b                   	pop    %ebx
801035b8:	5e                   	pop    %esi
801035b9:	5f                   	pop    %edi
801035ba:	5d                   	pop    %ebp
801035bb:	c3                   	ret    
801035bc:	66 90                	xchg   %ax,%ax
801035be:	66 90                	xchg   %ax,%ax

801035c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035c6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035cd:	e8 ae 0d 00 00       	call   80104380 <release>

  if (first) {
801035d2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035d7:	85 c0                	test   %eax,%eax
801035d9:	75 05                	jne    801035e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035db:	c9                   	leave  
801035dc:	c3                   	ret    
801035dd:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801035e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801035e7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035ee:	00 00 00 
    iinit(ROOTDEV);
801035f1:	e8 7a de ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
801035f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035fd:	e8 5e f5 ff ff       	call   80102b60 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103602:	c9                   	leave  
80103603:	c3                   	ret    
80103604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010360a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103610 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103616:	c7 44 24 04 75 72 10 	movl   $0x80107275,0x4(%esp)
8010361d:	80 
8010361e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103625:	e8 76 0b 00 00       	call   801041a0 <initlock>
}
8010362a:	c9                   	leave  
8010362b:	c3                   	ret    
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103630 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	56                   	push   %esi
80103634:	53                   	push   %ebx
80103635:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103638:	9c                   	pushf  
80103639:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010363a:	f6 c4 02             	test   $0x2,%ah
8010363d:	75 57                	jne    80103696 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010363f:	e8 1c f1 ff ff       	call   80102760 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103644:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010364a:	85 f6                	test   %esi,%esi
8010364c:	7e 3c                	jle    8010368a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010364e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103655:	39 c2                	cmp    %eax,%edx
80103657:	74 2d                	je     80103686 <mycpu+0x56>
80103659:	b9 30 28 11 80       	mov    $0x80112830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010365e:	31 d2                	xor    %edx,%edx
80103660:	83 c2 01             	add    $0x1,%edx
80103663:	39 f2                	cmp    %esi,%edx
80103665:	74 23                	je     8010368a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103667:	0f b6 19             	movzbl (%ecx),%ebx
8010366a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103670:	39 c3                	cmp    %eax,%ebx
80103672:	75 ec                	jne    80103660 <mycpu+0x30>
      return &cpus[i];
80103674:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010367a:	83 c4 10             	add    $0x10,%esp
8010367d:	5b                   	pop    %ebx
8010367e:	5e                   	pop    %esi
8010367f:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103680:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103685:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103686:	31 d2                	xor    %edx,%edx
80103688:	eb ea                	jmp    80103674 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010368a:	c7 04 24 7c 72 10 80 	movl   $0x8010727c,(%esp)
80103691:	e8 ca cc ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103696:	c7 04 24 58 73 10 80 	movl   $0x80107358,(%esp)
8010369d:	e8 be cc ff ff       	call   80100360 <panic>
801036a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036b0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036b6:	e8 75 ff ff ff       	call   80103630 <mycpu>
}
801036bb:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801036bc:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036c1:	c1 f8 04             	sar    $0x4,%eax
801036c4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ca:	c3                   	ret    
801036cb:	90                   	nop
801036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036d0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	53                   	push   %ebx
801036d4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801036d7:	e8 44 0b 00 00       	call   80104220 <pushcli>
  c = mycpu();
801036dc:	e8 4f ff ff ff       	call   80103630 <mycpu>
  p = c->proc;
801036e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036e7:	e8 74 0b 00 00       	call   80104260 <popcli>
  return p;
}
801036ec:	83 c4 04             	add    $0x4,%esp
801036ef:	89 d8                	mov    %ebx,%eax
801036f1:	5b                   	pop    %ebx
801036f2:	5d                   	pop    %ebp
801036f3:	c3                   	ret    
801036f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103700 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
struct proc*
allocproc(void)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103704:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
struct proc*
allocproc(void)
{
80103709:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010370c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103713:	e8 f8 0b 00 00       	call   80104310 <acquire>
80103718:	eb 11                	jmp    8010372b <allocproc+0x2b>
8010371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103720:	83 c3 7c             	add    $0x7c,%ebx
80103723:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103729:	74 7d                	je     801037a8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010372b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010372e:	85 c0                	test   %eax,%eax
80103730:	75 ee                	jne    80103720 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103732:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103737:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010373e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103745:	8d 50 01             	lea    0x1(%eax),%edx
80103748:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010374e:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103751:	e8 2a 0c 00 00       	call   80104380 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103756:	e8 45 ed ff ff       	call   801024a0 <kalloc>
8010375b:	85 c0                	test   %eax,%eax
8010375d:	89 43 08             	mov    %eax,0x8(%ebx)
80103760:	74 5a                	je     801037bc <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103762:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103768:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010376d:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103770:	c7 40 14 05 55 10 80 	movl   $0x80105505,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103777:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010377e:	00 
8010377f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103786:	00 
80103787:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010378a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010378d:	e8 3e 0c 00 00       	call   801043d0 <memset>
  p->context->eip = (uint)forkret;
80103792:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103795:	c7 40 10 c0 35 10 80 	movl   $0x801035c0,0x10(%eax)

  return p;
8010379c:	89 d8                	mov    %ebx,%eax
}
8010379e:	83 c4 14             	add    $0x14,%esp
801037a1:	5b                   	pop    %ebx
801037a2:	5d                   	pop    %ebp
801037a3:	c3                   	ret    
801037a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801037a8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037af:	e8 cc 0b 00 00       	call   80104380 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801037b4:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
801037b7:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801037b9:	5b                   	pop    %ebx
801037ba:	5d                   	pop    %ebp
801037bb:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801037bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801037c3:	eb d9                	jmp    8010379e <allocproc+0x9e>
801037c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037d0 <userinit>:
}
//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	53                   	push   %ebx
801037d4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801037d7:	e8 24 ff ff ff       	call   80103700 <allocproc>
801037dc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801037de:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801037e3:	e8 88 32 00 00       	call   80106a70 <setupkvm>
801037e8:	85 c0                	test   %eax,%eax
801037ea:	89 43 04             	mov    %eax,0x4(%ebx)
801037ed:	0f 84 d4 00 00 00    	je     801038c7 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037f3:	89 04 24             	mov    %eax,(%esp)
801037f6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801037fd:	00 
801037fe:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103805:	80 
80103806:	e8 95 2f 00 00       	call   801067a0 <inituvm>
  p->sz = PGSIZE;
8010380b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103811:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103818:	00 
80103819:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103820:	00 
80103821:	8b 43 18             	mov    0x18(%ebx),%eax
80103824:	89 04 24             	mov    %eax,(%esp)
80103827:	e8 a4 0b 00 00       	call   801043d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010382c:	8b 43 18             	mov    0x18(%ebx),%eax
8010382f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103834:	b9 23 00 00 00       	mov    $0x23,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103839:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010383d:	8b 43 18             	mov    0x18(%ebx),%eax
80103840:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103844:	8b 43 18             	mov    0x18(%ebx),%eax
80103847:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010384b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010384f:	8b 43 18             	mov    0x18(%ebx),%eax
80103852:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103856:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010385a:	8b 43 18             	mov    0x18(%ebx),%eax
8010385d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103864:	8b 43 18             	mov    0x18(%ebx),%eax
80103867:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010386e:	8b 43 18             	mov    0x18(%ebx),%eax
80103871:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103878:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010387b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103882:	00 
80103883:	c7 44 24 04 a5 72 10 	movl   $0x801072a5,0x4(%esp)
8010388a:	80 
8010388b:	89 04 24             	mov    %eax,(%esp)
8010388e:	e8 1d 0d 00 00       	call   801045b0 <safestrcpy>
  p->cwd = namei("/");
80103893:	c7 04 24 ae 72 10 80 	movl   $0x801072ae,(%esp)
8010389a:	e8 61 e6 ff ff       	call   80101f00 <namei>
8010389f:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801038a2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038a9:	e8 62 0a 00 00       	call   80104310 <acquire>

  p->state = RUNNABLE;
801038ae:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801038b5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038bc:	e8 bf 0a 00 00       	call   80104380 <release>
}
801038c1:	83 c4 14             	add    $0x14,%esp
801038c4:	5b                   	pop    %ebx
801038c5:	5d                   	pop    %ebp
801038c6:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801038c7:	c7 04 24 8c 72 10 80 	movl   $0x8010728c,(%esp)
801038ce:	e8 8d ca ff ff       	call   80100360 <panic>
801038d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038e0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	56                   	push   %esi
801038e4:	53                   	push   %ebx
801038e5:	83 ec 10             	sub    $0x10,%esp
801038e8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
801038eb:	e8 e0 fd ff ff       	call   801036d0 <myproc>

  sz = curproc->sz;
  if(n > 0){
801038f0:	83 fe 00             	cmp    $0x0,%esi
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
801038f3:	89 c3                	mov    %eax,%ebx

  sz = curproc->sz;
801038f5:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801038f7:	7e 2f                	jle    80103928 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038f9:	01 c6                	add    %eax,%esi
801038fb:	89 74 24 08          	mov    %esi,0x8(%esp)
801038ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80103903:	8b 43 04             	mov    0x4(%ebx),%eax
80103906:	89 04 24             	mov    %eax,(%esp)
80103909:	e8 d2 2f 00 00       	call   801068e0 <allocuvm>
8010390e:	85 c0                	test   %eax,%eax
80103910:	74 36                	je     80103948 <growproc+0x68>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103912:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103914:	89 1c 24             	mov    %ebx,(%esp)
80103917:	e8 74 2d 00 00       	call   80106690 <switchuvm>
  return 0;
8010391c:	31 c0                	xor    %eax,%eax
}
8010391e:	83 c4 10             	add    $0x10,%esp
80103921:	5b                   	pop    %ebx
80103922:	5e                   	pop    %esi
80103923:	5d                   	pop    %ebp
80103924:	c3                   	ret    
80103925:	8d 76 00             	lea    0x0(%esi),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103928:	74 e8                	je     80103912 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010392a:	01 c6                	add    %eax,%esi
8010392c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103930:	89 44 24 04          	mov    %eax,0x4(%esp)
80103934:	8b 43 04             	mov    0x4(%ebx),%eax
80103937:	89 04 24             	mov    %eax,(%esp)
8010393a:	e8 91 30 00 00       	call   801069d0 <deallocuvm>
8010393f:	85 c0                	test   %eax,%eax
80103941:	75 cf                	jne    80103912 <growproc+0x32>
80103943:	90                   	nop
80103944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010394d:	eb cf                	jmp    8010391e <growproc+0x3e>
8010394f:	90                   	nop

80103950 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	57                   	push   %edi
80103954:	56                   	push   %esi
80103955:	53                   	push   %ebx
80103956:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103959:	e8 72 fd ff ff       	call   801036d0 <myproc>
8010395e:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
80103960:	e8 9b fd ff ff       	call   80103700 <allocproc>
80103965:	85 c0                	test   %eax,%eax
80103967:	89 c7                	mov    %eax,%edi
80103969:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010396c:	0f 84 bc 00 00 00    	je     80103a2e <fork+0xde>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103972:	8b 03                	mov    (%ebx),%eax
80103974:	89 44 24 04          	mov    %eax,0x4(%esp)
80103978:	8b 43 04             	mov    0x4(%ebx),%eax
8010397b:	89 04 24             	mov    %eax,(%esp)
8010397e:	e8 cd 31 00 00       	call   80106b50 <copyuvm>
80103983:	85 c0                	test   %eax,%eax
80103985:	89 47 04             	mov    %eax,0x4(%edi)
80103988:	0f 84 a7 00 00 00    	je     80103a35 <fork+0xe5>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010398e:	8b 03                	mov    (%ebx),%eax
80103990:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103993:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103995:	8b 79 18             	mov    0x18(%ecx),%edi
80103998:	89 c8                	mov    %ecx,%eax
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
8010399a:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010399d:	8b 73 18             	mov    0x18(%ebx),%esi
801039a0:	b9 13 00 00 00       	mov    $0x13,%ecx
801039a5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039a7:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801039a9:	8b 40 18             	mov    0x18(%eax),%eax
801039ac:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801039b3:	90                   	nop
801039b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801039b8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801039bc:	85 c0                	test   %eax,%eax
801039be:	74 0f                	je     801039cf <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801039c0:	89 04 24             	mov    %eax,(%esp)
801039c3:	e8 18 d4 ff ff       	call   80100de0 <filedup>
801039c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801039cb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039cf:	83 c6 01             	add    $0x1,%esi
801039d2:	83 fe 10             	cmp    $0x10,%esi
801039d5:	75 e1                	jne    801039b8 <fork+0x68>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039d7:	8b 43 68             	mov    0x68(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039da:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039dd:	89 04 24             	mov    %eax,(%esp)
801039e0:	e8 9b dc ff ff       	call   80101680 <idup>
801039e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801039e8:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039eb:	8d 47 6c             	lea    0x6c(%edi),%eax
801039ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801039f2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801039f9:	00 
801039fa:	89 04 24             	mov    %eax,(%esp)
801039fd:	e8 ae 0b 00 00       	call   801045b0 <safestrcpy>

  pid = np->pid;
80103a02:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103a05:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a0c:	e8 ff 08 00 00       	call   80104310 <acquire>

  np->state = RUNNABLE;
80103a11:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103a18:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a1f:	e8 5c 09 00 00       	call   80104380 <release>

  return pid;
80103a24:	89 d8                	mov    %ebx,%eax
}
80103a26:	83 c4 1c             	add    $0x1c,%esp
80103a29:	5b                   	pop    %ebx
80103a2a:	5e                   	pop    %esi
80103a2b:	5f                   	pop    %edi
80103a2c:	5d                   	pop    %ebp
80103a2d:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a33:	eb f1                	jmp    80103a26 <fork+0xd6>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103a35:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a38:	8b 47 08             	mov    0x8(%edi),%eax
80103a3b:	89 04 24             	mov    %eax,(%esp)
80103a3e:	e8 ad e8 ff ff       	call   801022f0 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103a43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103a48:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103a4f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a56:	eb ce                	jmp    80103a26 <fork+0xd6>
80103a58:	90                   	nop
80103a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a60 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	57                   	push   %edi
80103a64:	56                   	push   %esi
80103a65:	53                   	push   %ebx
80103a66:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103a69:	e8 c2 fb ff ff       	call   80103630 <mycpu>
80103a6e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a70:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a77:	00 00 00 
80103a7a:	8d 78 04             	lea    0x4(%eax),%edi
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a80:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a81:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a88:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a8d:	e8 7e 08 00 00       	call   80104310 <acquire>
80103a92:	eb 0f                	jmp    80103aa3 <scheduler+0x43>
80103a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a98:	83 c3 7c             	add    $0x7c,%ebx
80103a9b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103aa1:	74 45                	je     80103ae8 <scheduler+0x88>
      if(p->state != RUNNABLE)
80103aa3:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103aa7:	75 ef                	jne    80103a98 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103aa9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103aaf:	89 1c 24             	mov    %ebx,(%esp)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ab2:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ab5:	e8 d6 2b 00 00       	call   80106690 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103aba:	8b 43 a0             	mov    -0x60(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103abd:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
80103ac4:	89 3c 24             	mov    %edi,(%esp)
80103ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103acb:	e8 3b 0b 00 00       	call   8010460b <swtch>
      switchkvm();
80103ad0:	e8 9b 2b 00 00       	call   80106670 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ad5:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103adb:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ae2:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ae5:	75 bc                	jne    80103aa3 <scheduler+0x43>
80103ae7:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103ae8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103aef:	e8 8c 08 00 00       	call   80104380 <release>

  }
80103af4:	eb 8a                	jmp    80103a80 <scheduler+0x20>
80103af6:	8d 76 00             	lea    0x0(%esi),%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b00 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
80103b05:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103b08:	e8 c3 fb ff ff       	call   801036d0 <myproc>

  if(!holding(&ptable.lock))
80103b0d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103b14:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103b16:	e8 b5 07 00 00       	call   801042d0 <holding>
80103b1b:	85 c0                	test   %eax,%eax
80103b1d:	74 4f                	je     80103b6e <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103b1f:	e8 0c fb ff ff       	call   80103630 <mycpu>
80103b24:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b2b:	75 65                	jne    80103b92 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103b2d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b31:	74 53                	je     80103b86 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b33:	9c                   	pushf  
80103b34:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103b35:	f6 c4 02             	test   $0x2,%ah
80103b38:	75 40                	jne    80103b7a <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b3a:	e8 f1 fa ff ff       	call   80103630 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b3f:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b42:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b48:	e8 e3 fa ff ff       	call   80103630 <mycpu>
80103b4d:	8b 40 04             	mov    0x4(%eax),%eax
80103b50:	89 1c 24             	mov    %ebx,(%esp)
80103b53:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b57:	e8 af 0a 00 00       	call   8010460b <swtch>
  mycpu()->intena = intena;
80103b5c:	e8 cf fa ff ff       	call   80103630 <mycpu>
80103b61:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b67:	83 c4 10             	add    $0x10,%esp
80103b6a:	5b                   	pop    %ebx
80103b6b:	5e                   	pop    %esi
80103b6c:	5d                   	pop    %ebp
80103b6d:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b6e:	c7 04 24 b0 72 10 80 	movl   $0x801072b0,(%esp)
80103b75:	e8 e6 c7 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b7a:	c7 04 24 dc 72 10 80 	movl   $0x801072dc,(%esp)
80103b81:	e8 da c7 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b86:	c7 04 24 ce 72 10 80 	movl   $0x801072ce,(%esp)
80103b8d:	e8 ce c7 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103b92:	c7 04 24 c2 72 10 80 	movl   $0x801072c2,(%esp)
80103b99:	e8 c2 c7 ff ff       	call   80100360 <panic>
80103b9e:	66 90                	xchg   %ax,%ax

80103ba0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103ba4:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103ba6:	53                   	push   %ebx
80103ba7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103baa:	e8 21 fb ff ff       	call   801036d0 <myproc>
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103baf:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103bb5:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103bb7:	0f 84 ea 00 00 00    	je     80103ca7 <exit+0x107>
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103bc0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bc4:	85 c0                	test   %eax,%eax
80103bc6:	74 10                	je     80103bd8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103bc8:	89 04 24             	mov    %eax,(%esp)
80103bcb:	e8 60 d2 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103bd0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103bd7:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103bd8:	83 c6 01             	add    $0x1,%esi
80103bdb:	83 fe 10             	cmp    $0x10,%esi
80103bde:	75 e0                	jne    80103bc0 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103be0:	e8 2b f0 ff ff       	call   80102c10 <begin_op>
  iput(curproc->cwd);
80103be5:	8b 43 68             	mov    0x68(%ebx),%eax
80103be8:	89 04 24             	mov    %eax,(%esp)
80103beb:	e8 e0 db ff ff       	call   801017d0 <iput>
  end_op();
80103bf0:	e8 8b f0 ff ff       	call   80102c80 <end_op>
  curproc->cwd = 0;
80103bf5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103bfc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c03:	e8 08 07 00 00       	call   80104310 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103c08:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c0b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c10:	eb 11                	jmp    80103c23 <exit+0x83>
80103c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c18:	83 c2 7c             	add    $0x7c,%edx
80103c1b:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103c21:	74 1d                	je     80103c40 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103c23:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c27:	75 ef                	jne    80103c18 <exit+0x78>
80103c29:	3b 42 20             	cmp    0x20(%edx),%eax
80103c2c:	75 ea                	jne    80103c18 <exit+0x78>
      p->state = RUNNABLE;
80103c2e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c35:	83 c2 7c             	add    $0x7c,%edx
80103c38:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103c3e:	75 e3                	jne    80103c23 <exit+0x83>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c40:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103c45:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103c4a:	eb 0f                	jmp    80103c5b <exit+0xbb>
80103c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c50:	83 c1 7c             	add    $0x7c,%ecx
80103c53:	81 f9 54 4c 11 80    	cmp    $0x80114c54,%ecx
80103c59:	74 34                	je     80103c8f <exit+0xef>
    if(p->parent == curproc){
80103c5b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103c5e:	75 f0                	jne    80103c50 <exit+0xb0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c60:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c64:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103c67:	75 e7                	jne    80103c50 <exit+0xb0>
80103c69:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c6e:	eb 0b                	jmp    80103c7b <exit+0xdb>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c70:	83 c2 7c             	add    $0x7c,%edx
80103c73:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103c79:	74 d5                	je     80103c50 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103c7b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c7f:	75 ef                	jne    80103c70 <exit+0xd0>
80103c81:	3b 42 20             	cmp    0x20(%edx),%eax
80103c84:	75 ea                	jne    80103c70 <exit+0xd0>
      p->state = RUNNABLE;
80103c86:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103c8d:	eb e1                	jmp    80103c70 <exit+0xd0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c8f:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103c96:	e8 65 fe ff ff       	call   80103b00 <sched>
  panic("zombie exit");
80103c9b:	c7 04 24 fd 72 10 80 	movl   $0x801072fd,(%esp)
80103ca2:	e8 b9 c6 ff ff       	call   80100360 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103ca7:	c7 04 24 f0 72 10 80 	movl   $0x801072f0,(%esp)
80103cae:	e8 ad c6 ff ff       	call   80100360 <panic>
80103cb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cc0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103cc6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ccd:	e8 3e 06 00 00       	call   80104310 <acquire>
  myproc()->state = RUNNABLE;
80103cd2:	e8 f9 f9 ff ff       	call   801036d0 <myproc>
80103cd7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103cde:	e8 1d fe ff ff       	call   80103b00 <sched>
  release(&ptable.lock);
80103ce3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cea:	e8 91 06 00 00       	call   80104380 <release>
}
80103cef:	c9                   	leave  
80103cf0:	c3                   	ret    
80103cf1:	eb 0d                	jmp    80103d00 <sleep>
80103cf3:	90                   	nop
80103cf4:	90                   	nop
80103cf5:	90                   	nop
80103cf6:	90                   	nop
80103cf7:	90                   	nop
80103cf8:	90                   	nop
80103cf9:	90                   	nop
80103cfa:	90                   	nop
80103cfb:	90                   	nop
80103cfc:	90                   	nop
80103cfd:	90                   	nop
80103cfe:	90                   	nop
80103cff:	90                   	nop

80103d00 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 1c             	sub    $0x1c,%esp
80103d09:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103d0f:	e8 bc f9 ff ff       	call   801036d0 <myproc>
  
  if(p == 0)
80103d14:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103d16:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103d18:	0f 84 7c 00 00 00    	je     80103d9a <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103d1e:	85 f6                	test   %esi,%esi
80103d20:	74 6c                	je     80103d8e <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d22:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103d28:	74 46                	je     80103d70 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d2a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d31:	e8 da 05 00 00       	call   80104310 <acquire>
    release(lk);
80103d36:	89 34 24             	mov    %esi,(%esp)
80103d39:	e8 42 06 00 00       	call   80104380 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103d3e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d41:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103d48:	e8 b3 fd ff ff       	call   80103b00 <sched>

  // Tidy up.
  p->chan = 0;
80103d4d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d54:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d5b:	e8 20 06 00 00       	call   80104380 <release>
    acquire(lk);
80103d60:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103d63:	83 c4 1c             	add    $0x1c,%esp
80103d66:	5b                   	pop    %ebx
80103d67:	5e                   	pop    %esi
80103d68:	5f                   	pop    %edi
80103d69:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d6a:	e9 a1 05 00 00       	jmp    80104310 <acquire>
80103d6f:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d70:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103d73:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103d7a:	e8 81 fd ff ff       	call   80103b00 <sched>

  // Tidy up.
  p->chan = 0;
80103d7f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103d86:	83 c4 1c             	add    $0x1c,%esp
80103d89:	5b                   	pop    %ebx
80103d8a:	5e                   	pop    %esi
80103d8b:	5f                   	pop    %edi
80103d8c:	5d                   	pop    %ebp
80103d8d:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103d8e:	c7 04 24 0f 73 10 80 	movl   $0x8010730f,(%esp)
80103d95:	e8 c6 c5 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103d9a:	c7 04 24 09 73 10 80 	movl   $0x80107309,(%esp)
80103da1:	e8 ba c5 ff ff       	call   80100360 <panic>
80103da6:	8d 76 00             	lea    0x0(%esi),%esi
80103da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103db0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	56                   	push   %esi
80103db4:	53                   	push   %ebx
80103db5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103db8:	e8 13 f9 ff ff       	call   801036d0 <myproc>
  
  acquire(&ptable.lock);
80103dbd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103dc4:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103dc6:	e8 45 05 00 00       	call   80104310 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103dcb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dcd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103dd2:	eb 0f                	jmp    80103de3 <wait+0x33>
80103dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dd8:	83 c3 7c             	add    $0x7c,%ebx
80103ddb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103de1:	74 1d                	je     80103e00 <wait+0x50>
      if(p->parent != curproc)
80103de3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103de6:	75 f0                	jne    80103dd8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103de8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103dec:	74 2f                	je     80103e1d <wait+0x6d>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dee:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103df1:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df6:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103dfc:	75 e5                	jne    80103de3 <wait+0x33>
80103dfe:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103e00:	85 c0                	test   %eax,%eax
80103e02:	74 6e                	je     80103e72 <wait+0xc2>
80103e04:	8b 46 24             	mov    0x24(%esi),%eax
80103e07:	85 c0                	test   %eax,%eax
80103e09:	75 67                	jne    80103e72 <wait+0xc2>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e0b:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103e12:	80 
80103e13:	89 34 24             	mov    %esi,(%esp)
80103e16:	e8 e5 fe ff ff       	call   80103d00 <sleep>
  }
80103e1b:	eb ae                	jmp    80103dcb <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e1d:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e20:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e23:	89 04 24             	mov    %eax,(%esp)
80103e26:	e8 c5 e4 ff ff       	call   801022f0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e2b:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e2e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e35:	89 04 24             	mov    %eax,(%esp)
80103e38:	e8 b3 2b 00 00       	call   801069f0 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103e3d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103e44:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e4b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e52:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e56:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e5d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e64:	e8 17 05 00 00       	call   80104380 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e69:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e6c:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e6e:	5b                   	pop    %ebx
80103e6f:	5e                   	pop    %esi
80103e70:	5d                   	pop    %ebp
80103e71:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103e72:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e79:	e8 02 05 00 00       	call   80104380 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e7e:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e86:	5b                   	pop    %ebx
80103e87:	5e                   	pop    %esi
80103e88:	5d                   	pop    %ebp
80103e89:	c3                   	ret    
80103e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e90 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	53                   	push   %ebx
80103e94:	83 ec 14             	sub    $0x14,%esp
80103e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103e9a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ea1:	e8 6a 04 00 00       	call   80104310 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ea6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103eab:	eb 0d                	jmp    80103eba <wakeup+0x2a>
80103ead:	8d 76 00             	lea    0x0(%esi),%esi
80103eb0:	83 c0 7c             	add    $0x7c,%eax
80103eb3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103eb8:	74 1e                	je     80103ed8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103eba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ebe:	75 f0                	jne    80103eb0 <wakeup+0x20>
80103ec0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103ec3:	75 eb                	jne    80103eb0 <wakeup+0x20>
      p->state = RUNNABLE;
80103ec5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ecc:	83 c0 7c             	add    $0x7c,%eax
80103ecf:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103ed4:	75 e4                	jne    80103eba <wakeup+0x2a>
80103ed6:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ed8:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103edf:	83 c4 14             	add    $0x14,%esp
80103ee2:	5b                   	pop    %ebx
80103ee3:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ee4:	e9 97 04 00 00       	jmp    80104380 <release>
80103ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ef0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	53                   	push   %ebx
80103ef4:	83 ec 14             	sub    $0x14,%esp
80103ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103efa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f01:	e8 0a 04 00 00       	call   80104310 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f06:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f0b:	eb 0d                	jmp    80103f1a <kill+0x2a>
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi
80103f10:	83 c0 7c             	add    $0x7c,%eax
80103f13:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103f18:	74 36                	je     80103f50 <kill+0x60>
    if(p->pid == pid){
80103f1a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f1d:	75 f1                	jne    80103f10 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f1f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103f23:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f2a:	74 14                	je     80103f40 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f2c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f33:	e8 48 04 00 00       	call   80104380 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f38:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103f3b:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f3d:	5b                   	pop    %ebx
80103f3e:	5d                   	pop    %ebp
80103f3f:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103f40:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f47:	eb e3                	jmp    80103f2c <kill+0x3c>
80103f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f50:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f57:	e8 24 04 00 00       	call   80104380 <release>
  return -1;
}
80103f5c:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f64:	5b                   	pop    %ebx
80103f65:	5d                   	pop    %ebp
80103f66:	c3                   	ret    
80103f67:	89 f6                	mov    %esi,%esi
80103f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f70 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	53                   	push   %ebx
80103f76:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103f7b:	83 ec 4c             	sub    $0x4c,%esp
80103f7e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103f81:	eb 20                	jmp    80103fa3 <procdump+0x33>
80103f83:	90                   	nop
80103f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103f88:	c7 04 24 97 76 10 80 	movl   $0x80107697,(%esp)
80103f8f:	e8 bc c6 ff ff       	call   80100650 <cprintf>
80103f94:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f97:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80103f9d:	0f 84 8d 00 00 00    	je     80104030 <procdump+0xc0>
    if(p->state == UNUSED)
80103fa3:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103fa6:	85 c0                	test   %eax,%eax
80103fa8:	74 ea                	je     80103f94 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103faa:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103fad:	ba 20 73 10 80       	mov    $0x80107320,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fb2:	77 11                	ja     80103fc5 <procdump+0x55>
80103fb4:	8b 14 85 80 73 10 80 	mov    -0x7fef8c80(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103fbb:	b8 20 73 10 80       	mov    $0x80107320,%eax
80103fc0:	85 d2                	test   %edx,%edx
80103fc2:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103fc5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103fc8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103fcc:	89 54 24 08          	mov    %edx,0x8(%esp)
80103fd0:	c7 04 24 24 73 10 80 	movl   $0x80107324,(%esp)
80103fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fdb:	e8 70 c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103fe0:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103fe4:	75 a2                	jne    80103f88 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103fe6:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fed:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103ff0:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103ff3:	8b 40 0c             	mov    0xc(%eax),%eax
80103ff6:	83 c0 08             	add    $0x8,%eax
80103ff9:	89 04 24             	mov    %eax,(%esp)
80103ffc:	e8 bf 01 00 00       	call   801041c0 <getcallerpcs>
80104001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104008:	8b 17                	mov    (%edi),%edx
8010400a:	85 d2                	test   %edx,%edx
8010400c:	0f 84 76 ff ff ff    	je     80103f88 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104012:	89 54 24 04          	mov    %edx,0x4(%esp)
80104016:	83 c7 04             	add    $0x4,%edi
80104019:	c7 04 24 61 6d 10 80 	movl   $0x80106d61,(%esp)
80104020:	e8 2b c6 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104025:	39 f7                	cmp    %esi,%edi
80104027:	75 df                	jne    80104008 <procdump+0x98>
80104029:	e9 5a ff ff ff       	jmp    80103f88 <procdump+0x18>
8010402e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104030:	83 c4 4c             	add    $0x4c,%esp
80104033:	5b                   	pop    %ebx
80104034:	5e                   	pop    %esi
80104035:	5f                   	pop    %edi
80104036:	5d                   	pop    %ebp
80104037:	c3                   	ret    
80104038:	90                   	nop
80104039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104040 <setproc>:

void 
setproc(struct proc *p){
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 14             	sub    $0x14,%esp
80104047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010404a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104051:	e8 ba 02 00 00       	call   80104310 <acquire>

  p->state = RUNNABLE;
80104056:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010405d:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104064:	83 c4 14             	add    $0x14,%esp
80104067:	5b                   	pop    %ebx
80104068:	5d                   	pop    %ebp
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
80104069:	e9 12 03 00 00       	jmp    80104380 <release>
8010406e:	66 90                	xchg   %ax,%ax

80104070 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	53                   	push   %ebx
80104074:	83 ec 14             	sub    $0x14,%esp
80104077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010407a:	c7 44 24 04 98 73 10 	movl   $0x80107398,0x4(%esp)
80104081:	80 
80104082:	8d 43 04             	lea    0x4(%ebx),%eax
80104085:	89 04 24             	mov    %eax,(%esp)
80104088:	e8 13 01 00 00       	call   801041a0 <initlock>
  lk->name = name;
8010408d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104090:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104096:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010409d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801040a0:	83 c4 14             	add    $0x14,%esp
801040a3:	5b                   	pop    %ebx
801040a4:	5d                   	pop    %ebp
801040a5:	c3                   	ret    
801040a6:	8d 76 00             	lea    0x0(%esi),%esi
801040a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	56                   	push   %esi
801040b4:	53                   	push   %ebx
801040b5:	83 ec 10             	sub    $0x10,%esp
801040b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040bb:	8d 73 04             	lea    0x4(%ebx),%esi
801040be:	89 34 24             	mov    %esi,(%esp)
801040c1:	e8 4a 02 00 00       	call   80104310 <acquire>
  while (lk->locked) {
801040c6:	8b 13                	mov    (%ebx),%edx
801040c8:	85 d2                	test   %edx,%edx
801040ca:	74 16                	je     801040e2 <acquiresleep+0x32>
801040cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801040d0:	89 74 24 04          	mov    %esi,0x4(%esp)
801040d4:	89 1c 24             	mov    %ebx,(%esp)
801040d7:	e8 24 fc ff ff       	call   80103d00 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801040dc:	8b 03                	mov    (%ebx),%eax
801040de:	85 c0                	test   %eax,%eax
801040e0:	75 ee                	jne    801040d0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801040e2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801040e8:	e8 e3 f5 ff ff       	call   801036d0 <myproc>
801040ed:	8b 40 10             	mov    0x10(%eax),%eax
801040f0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801040f3:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040f6:	83 c4 10             	add    $0x10,%esp
801040f9:	5b                   	pop    %ebx
801040fa:	5e                   	pop    %esi
801040fb:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801040fc:	e9 7f 02 00 00       	jmp    80104380 <release>
80104101:	eb 0d                	jmp    80104110 <releasesleep>
80104103:	90                   	nop
80104104:	90                   	nop
80104105:	90                   	nop
80104106:	90                   	nop
80104107:	90                   	nop
80104108:	90                   	nop
80104109:	90                   	nop
8010410a:	90                   	nop
8010410b:	90                   	nop
8010410c:	90                   	nop
8010410d:	90                   	nop
8010410e:	90                   	nop
8010410f:	90                   	nop

80104110 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	56                   	push   %esi
80104114:	53                   	push   %ebx
80104115:	83 ec 10             	sub    $0x10,%esp
80104118:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010411b:	8d 73 04             	lea    0x4(%ebx),%esi
8010411e:	89 34 24             	mov    %esi,(%esp)
80104121:	e8 ea 01 00 00       	call   80104310 <acquire>
  lk->locked = 0;
80104126:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010412c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104133:	89 1c 24             	mov    %ebx,(%esp)
80104136:	e8 55 fd ff ff       	call   80103e90 <wakeup>
  release(&lk->lk);
8010413b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010413e:	83 c4 10             	add    $0x10,%esp
80104141:	5b                   	pop    %ebx
80104142:	5e                   	pop    %esi
80104143:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104144:	e9 37 02 00 00       	jmp    80104380 <release>
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104150 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
80104154:	31 ff                	xor    %edi,%edi
  release(&lk->lk);
}

int
holdingsleep(struct sleeplock *lk)
{
80104156:	56                   	push   %esi
80104157:	53                   	push   %ebx
80104158:	83 ec 1c             	sub    $0x1c,%esp
8010415b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010415e:	8d 73 04             	lea    0x4(%ebx),%esi
80104161:	89 34 24             	mov    %esi,(%esp)
80104164:	e8 a7 01 00 00       	call   80104310 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104169:	8b 03                	mov    (%ebx),%eax
8010416b:	85 c0                	test   %eax,%eax
8010416d:	74 13                	je     80104182 <holdingsleep+0x32>
8010416f:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104172:	e8 59 f5 ff ff       	call   801036d0 <myproc>
80104177:	3b 58 10             	cmp    0x10(%eax),%ebx
8010417a:	0f 94 c0             	sete   %al
8010417d:	0f b6 c0             	movzbl %al,%eax
80104180:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104182:	89 34 24             	mov    %esi,(%esp)
80104185:	e8 f6 01 00 00       	call   80104380 <release>
  return r;
}
8010418a:	83 c4 1c             	add    $0x1c,%esp
8010418d:	89 f8                	mov    %edi,%eax
8010418f:	5b                   	pop    %ebx
80104190:	5e                   	pop    %esi
80104191:	5f                   	pop    %edi
80104192:	5d                   	pop    %ebp
80104193:	c3                   	ret    
80104194:	66 90                	xchg   %ax,%ax
80104196:	66 90                	xchg   %ax,%ax
80104198:	66 90                	xchg   %ax,%ax
8010419a:	66 90                	xchg   %ax,%ax
8010419c:	66 90                	xchg   %ax,%ax
8010419e:	66 90                	xchg   %ax,%ax

801041a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801041a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801041a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801041af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801041b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801041b9:	5d                   	pop    %ebp
801041ba:	c3                   	ret    
801041bb:	90                   	nop
801041bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041c3:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801041c9:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041ca:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801041cd:	31 c0                	xor    %eax,%eax
801041cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801041d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801041d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801041dc:	77 1a                	ja     801041f8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801041de:	8b 5a 04             	mov    0x4(%edx),%ebx
801041e1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041e4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801041e7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041e9:	83 f8 0a             	cmp    $0xa,%eax
801041ec:	75 e2                	jne    801041d0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801041ee:	5b                   	pop    %ebx
801041ef:	5d                   	pop    %ebp
801041f0:	c3                   	ret    
801041f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801041f8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041ff:	83 c0 01             	add    $0x1,%eax
80104202:	83 f8 0a             	cmp    $0xa,%eax
80104205:	74 e7                	je     801041ee <getcallerpcs+0x2e>
    pcs[i] = 0;
80104207:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010420e:	83 c0 01             	add    $0x1,%eax
80104211:	83 f8 0a             	cmp    $0xa,%eax
80104214:	75 e2                	jne    801041f8 <getcallerpcs+0x38>
80104216:	eb d6                	jmp    801041ee <getcallerpcs+0x2e>
80104218:	90                   	nop
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104220 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 04             	sub    $0x4,%esp
80104227:	9c                   	pushf  
80104228:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104229:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010422a:	e8 01 f4 ff ff       	call   80103630 <mycpu>
8010422f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104235:	85 c0                	test   %eax,%eax
80104237:	75 11                	jne    8010424a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104239:	e8 f2 f3 ff ff       	call   80103630 <mycpu>
8010423e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104244:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010424a:	e8 e1 f3 ff ff       	call   80103630 <mycpu>
8010424f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104256:	83 c4 04             	add    $0x4,%esp
80104259:	5b                   	pop    %ebx
8010425a:	5d                   	pop    %ebp
8010425b:	c3                   	ret    
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104260 <popcli>:

void
popcli(void)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104266:	9c                   	pushf  
80104267:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104268:	f6 c4 02             	test   $0x2,%ah
8010426b:	75 49                	jne    801042b6 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010426d:	e8 be f3 ff ff       	call   80103630 <mycpu>
80104272:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104278:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010427b:	85 d2                	test   %edx,%edx
8010427d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104283:	78 25                	js     801042aa <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104285:	e8 a6 f3 ff ff       	call   80103630 <mycpu>
8010428a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104290:	85 d2                	test   %edx,%edx
80104292:	74 04                	je     80104298 <popcli+0x38>
    sti();
}
80104294:	c9                   	leave  
80104295:	c3                   	ret    
80104296:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104298:	e8 93 f3 ff ff       	call   80103630 <mycpu>
8010429d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801042a3:	85 c0                	test   %eax,%eax
801042a5:	74 ed                	je     80104294 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801042a7:	fb                   	sti    
    sti();
}
801042a8:	c9                   	leave  
801042a9:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
801042aa:	c7 04 24 ba 73 10 80 	movl   $0x801073ba,(%esp)
801042b1:	e8 aa c0 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801042b6:	c7 04 24 a3 73 10 80 	movl   $0x801073a3,(%esp)
801042bd:	e8 9e c0 ff ff       	call   80100360 <panic>
801042c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042d0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	56                   	push   %esi
  int r;
  pushcli();
  r = lock->locked && lock->cpu == mycpu();
801042d4:	31 f6                	xor    %esi,%esi
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042d6:	53                   	push   %ebx
801042d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  pushcli();
801042da:	e8 41 ff ff ff       	call   80104220 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801042df:	8b 03                	mov    (%ebx),%eax
801042e1:	85 c0                	test   %eax,%eax
801042e3:	74 12                	je     801042f7 <holding+0x27>
801042e5:	8b 5b 08             	mov    0x8(%ebx),%ebx
801042e8:	e8 43 f3 ff ff       	call   80103630 <mycpu>
801042ed:	39 c3                	cmp    %eax,%ebx
801042ef:	0f 94 c0             	sete   %al
801042f2:	0f b6 c0             	movzbl %al,%eax
801042f5:	89 c6                	mov    %eax,%esi
  popcli();
801042f7:	e8 64 ff ff ff       	call   80104260 <popcli>
  return r;
}
801042fc:	89 f0                	mov    %esi,%eax
801042fe:	5b                   	pop    %ebx
801042ff:	5e                   	pop    %esi
80104300:	5d                   	pop    %ebp
80104301:	c3                   	ret    
80104302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104310 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104317:	e8 04 ff ff ff       	call   80104220 <pushcli>
  if(holding(lk))
8010431c:	8b 45 08             	mov    0x8(%ebp),%eax
8010431f:	89 04 24             	mov    %eax,(%esp)
80104322:	e8 a9 ff ff ff       	call   801042d0 <holding>
80104327:	85 c0                	test   %eax,%eax
80104329:	75 3c                	jne    80104367 <acquire+0x57>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010432b:	b9 01 00 00 00       	mov    $0x1,%ecx
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104330:	8b 55 08             	mov    0x8(%ebp),%edx
80104333:	89 c8                	mov    %ecx,%eax
80104335:	f0 87 02             	lock xchg %eax,(%edx)
80104338:	85 c0                	test   %eax,%eax
8010433a:	75 f4                	jne    80104330 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010433c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104341:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104344:	e8 e7 f2 ff ff       	call   80103630 <mycpu>
80104349:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010434c:	8b 45 08             	mov    0x8(%ebp),%eax
8010434f:	83 c0 0c             	add    $0xc,%eax
80104352:	89 44 24 04          	mov    %eax,0x4(%esp)
80104356:	8d 45 08             	lea    0x8(%ebp),%eax
80104359:	89 04 24             	mov    %eax,(%esp)
8010435c:	e8 5f fe ff ff       	call   801041c0 <getcallerpcs>
}
80104361:	83 c4 14             	add    $0x14,%esp
80104364:	5b                   	pop    %ebx
80104365:	5d                   	pop    %ebp
80104366:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104367:	c7 04 24 c1 73 10 80 	movl   $0x801073c1,(%esp)
8010436e:	e8 ed bf ff ff       	call   80100360 <panic>
80104373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104380 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 14             	sub    $0x14,%esp
80104387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010438a:	89 1c 24             	mov    %ebx,(%esp)
8010438d:	e8 3e ff ff ff       	call   801042d0 <holding>
80104392:	85 c0                	test   %eax,%eax
80104394:	74 23                	je     801043b9 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104396:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010439d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801043a4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801043a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801043af:	83 c4 14             	add    $0x14,%esp
801043b2:	5b                   	pop    %ebx
801043b3:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801043b4:	e9 a7 fe ff ff       	jmp    80104260 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801043b9:	c7 04 24 c9 73 10 80 	movl   $0x801073c9,(%esp)
801043c0:	e8 9b bf ff ff       	call   80100360 <panic>
801043c5:	66 90                	xchg   %ax,%ax
801043c7:	66 90                	xchg   %ax,%ax
801043c9:	66 90                	xchg   %ax,%ax
801043cb:	66 90                	xchg   %ax,%ax
801043cd:	66 90                	xchg   %ax,%ax
801043cf:	90                   	nop

801043d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	8b 55 08             	mov    0x8(%ebp),%edx
801043d6:	57                   	push   %edi
801043d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801043da:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801043db:	f6 c2 03             	test   $0x3,%dl
801043de:	75 05                	jne    801043e5 <memset+0x15>
801043e0:	f6 c1 03             	test   $0x3,%cl
801043e3:	74 13                	je     801043f8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801043e5:	89 d7                	mov    %edx,%edi
801043e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ea:	fc                   	cld    
801043eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801043ed:	5b                   	pop    %ebx
801043ee:	89 d0                	mov    %edx,%eax
801043f0:	5f                   	pop    %edi
801043f1:	5d                   	pop    %ebp
801043f2:	c3                   	ret    
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801043f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801043fc:	c1 e9 02             	shr    $0x2,%ecx
801043ff:	89 f8                	mov    %edi,%eax
80104401:	89 fb                	mov    %edi,%ebx
80104403:	c1 e0 18             	shl    $0x18,%eax
80104406:	c1 e3 10             	shl    $0x10,%ebx
80104409:	09 d8                	or     %ebx,%eax
8010440b:	09 f8                	or     %edi,%eax
8010440d:	c1 e7 08             	shl    $0x8,%edi
80104410:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104412:	89 d7                	mov    %edx,%edi
80104414:	fc                   	cld    
80104415:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104417:	5b                   	pop    %ebx
80104418:	89 d0                	mov    %edx,%eax
8010441a:	5f                   	pop    %edi
8010441b:	5d                   	pop    %ebp
8010441c:	c3                   	ret    
8010441d:	8d 76 00             	lea    0x0(%esi),%esi

80104420 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	8b 45 10             	mov    0x10(%ebp),%eax
80104426:	57                   	push   %edi
80104427:	56                   	push   %esi
80104428:	8b 75 0c             	mov    0xc(%ebp),%esi
8010442b:	53                   	push   %ebx
8010442c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010442f:	85 c0                	test   %eax,%eax
80104431:	8d 78 ff             	lea    -0x1(%eax),%edi
80104434:	74 26                	je     8010445c <memcmp+0x3c>
    if(*s1 != *s2)
80104436:	0f b6 03             	movzbl (%ebx),%eax
80104439:	31 d2                	xor    %edx,%edx
8010443b:	0f b6 0e             	movzbl (%esi),%ecx
8010443e:	38 c8                	cmp    %cl,%al
80104440:	74 16                	je     80104458 <memcmp+0x38>
80104442:	eb 24                	jmp    80104468 <memcmp+0x48>
80104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104448:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010444d:	83 c2 01             	add    $0x1,%edx
80104450:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104454:	38 c8                	cmp    %cl,%al
80104456:	75 10                	jne    80104468 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104458:	39 fa                	cmp    %edi,%edx
8010445a:	75 ec                	jne    80104448 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010445c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010445d:	31 c0                	xor    %eax,%eax
}
8010445f:	5e                   	pop    %esi
80104460:	5f                   	pop    %edi
80104461:	5d                   	pop    %ebp
80104462:	c3                   	ret    
80104463:	90                   	nop
80104464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104468:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104469:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010446b:	5e                   	pop    %esi
8010446c:	5f                   	pop    %edi
8010446d:	5d                   	pop    %ebp
8010446e:	c3                   	ret    
8010446f:	90                   	nop

80104470 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	8b 45 08             	mov    0x8(%ebp),%eax
80104477:	56                   	push   %esi
80104478:	8b 75 0c             	mov    0xc(%ebp),%esi
8010447b:	53                   	push   %ebx
8010447c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010447f:	39 c6                	cmp    %eax,%esi
80104481:	73 35                	jae    801044b8 <memmove+0x48>
80104483:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104486:	39 c8                	cmp    %ecx,%eax
80104488:	73 2e                	jae    801044b8 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010448a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010448c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010448f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104492:	74 1b                	je     801044af <memmove+0x3f>
80104494:	f7 db                	neg    %ebx
80104496:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104499:	01 fb                	add    %edi,%ebx
8010449b:	90                   	nop
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801044a0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044a4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801044a7:	83 ea 01             	sub    $0x1,%edx
801044aa:	83 fa ff             	cmp    $0xffffffff,%edx
801044ad:	75 f1                	jne    801044a0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801044af:	5b                   	pop    %ebx
801044b0:	5e                   	pop    %esi
801044b1:	5f                   	pop    %edi
801044b2:	5d                   	pop    %ebp
801044b3:	c3                   	ret    
801044b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044b8:	31 d2                	xor    %edx,%edx
801044ba:	85 db                	test   %ebx,%ebx
801044bc:	74 f1                	je     801044af <memmove+0x3f>
801044be:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801044c0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801044c7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044ca:	39 da                	cmp    %ebx,%edx
801044cc:	75 f2                	jne    801044c0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801044ce:	5b                   	pop    %ebx
801044cf:	5e                   	pop    %esi
801044d0:	5f                   	pop    %edi
801044d1:	5d                   	pop    %ebp
801044d2:	c3                   	ret    
801044d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801044e3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801044e4:	e9 87 ff ff ff       	jmp    80104470 <memmove>
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044f0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	8b 75 10             	mov    0x10(%ebp),%esi
801044f7:	53                   	push   %ebx
801044f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801044fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801044fe:	85 f6                	test   %esi,%esi
80104500:	74 30                	je     80104532 <strncmp+0x42>
80104502:	0f b6 01             	movzbl (%ecx),%eax
80104505:	84 c0                	test   %al,%al
80104507:	74 2f                	je     80104538 <strncmp+0x48>
80104509:	0f b6 13             	movzbl (%ebx),%edx
8010450c:	38 d0                	cmp    %dl,%al
8010450e:	75 46                	jne    80104556 <strncmp+0x66>
80104510:	8d 51 01             	lea    0x1(%ecx),%edx
80104513:	01 ce                	add    %ecx,%esi
80104515:	eb 14                	jmp    8010452b <strncmp+0x3b>
80104517:	90                   	nop
80104518:	0f b6 02             	movzbl (%edx),%eax
8010451b:	84 c0                	test   %al,%al
8010451d:	74 31                	je     80104550 <strncmp+0x60>
8010451f:	0f b6 19             	movzbl (%ecx),%ebx
80104522:	83 c2 01             	add    $0x1,%edx
80104525:	38 d8                	cmp    %bl,%al
80104527:	75 17                	jne    80104540 <strncmp+0x50>
    n--, p++, q++;
80104529:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010452b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010452d:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104530:	75 e6                	jne    80104518 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104532:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104533:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104535:	5e                   	pop    %esi
80104536:	5d                   	pop    %ebp
80104537:	c3                   	ret    
80104538:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010453b:	31 c0                	xor    %eax,%eax
8010453d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104540:	0f b6 d3             	movzbl %bl,%edx
80104543:	29 d0                	sub    %edx,%eax
}
80104545:	5b                   	pop    %ebx
80104546:	5e                   	pop    %esi
80104547:	5d                   	pop    %ebp
80104548:	c3                   	ret    
80104549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104550:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104554:	eb ea                	jmp    80104540 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104556:	89 d3                	mov    %edx,%ebx
80104558:	eb e6                	jmp    80104540 <strncmp+0x50>
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104560 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	8b 45 08             	mov    0x8(%ebp),%eax
80104566:	56                   	push   %esi
80104567:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010456a:	53                   	push   %ebx
8010456b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010456e:	89 c2                	mov    %eax,%edx
80104570:	eb 19                	jmp    8010458b <strncpy+0x2b>
80104572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104578:	83 c3 01             	add    $0x1,%ebx
8010457b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010457f:	83 c2 01             	add    $0x1,%edx
80104582:	84 c9                	test   %cl,%cl
80104584:	88 4a ff             	mov    %cl,-0x1(%edx)
80104587:	74 09                	je     80104592 <strncpy+0x32>
80104589:	89 f1                	mov    %esi,%ecx
8010458b:	85 c9                	test   %ecx,%ecx
8010458d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104590:	7f e6                	jg     80104578 <strncpy+0x18>
    ;
  while(n-- > 0)
80104592:	31 c9                	xor    %ecx,%ecx
80104594:	85 f6                	test   %esi,%esi
80104596:	7e 0f                	jle    801045a7 <strncpy+0x47>
    *s++ = 0;
80104598:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010459c:	89 f3                	mov    %esi,%ebx
8010459e:	83 c1 01             	add    $0x1,%ecx
801045a1:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801045a3:	85 db                	test   %ebx,%ebx
801045a5:	7f f1                	jg     80104598 <strncpy+0x38>
    *s++ = 0;
  return os;
}
801045a7:	5b                   	pop    %ebx
801045a8:	5e                   	pop    %esi
801045a9:	5d                   	pop    %ebp
801045aa:	c3                   	ret    
801045ab:	90                   	nop
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045b6:	56                   	push   %esi
801045b7:	8b 45 08             	mov    0x8(%ebp),%eax
801045ba:	53                   	push   %ebx
801045bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801045be:	85 c9                	test   %ecx,%ecx
801045c0:	7e 26                	jle    801045e8 <safestrcpy+0x38>
801045c2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801045c6:	89 c1                	mov    %eax,%ecx
801045c8:	eb 17                	jmp    801045e1 <safestrcpy+0x31>
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801045d0:	83 c2 01             	add    $0x1,%edx
801045d3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801045d7:	83 c1 01             	add    $0x1,%ecx
801045da:	84 db                	test   %bl,%bl
801045dc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801045df:	74 04                	je     801045e5 <safestrcpy+0x35>
801045e1:	39 f2                	cmp    %esi,%edx
801045e3:	75 eb                	jne    801045d0 <safestrcpy+0x20>
    ;
  *s = 0;
801045e5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801045e8:	5b                   	pop    %ebx
801045e9:	5e                   	pop    %esi
801045ea:	5d                   	pop    %ebp
801045eb:	c3                   	ret    
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045f0 <strlen>:

int
strlen(const char *s)
{
801045f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801045f1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801045f3:	89 e5                	mov    %esp,%ebp
801045f5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801045f8:	80 3a 00             	cmpb   $0x0,(%edx)
801045fb:	74 0c                	je     80104609 <strlen+0x19>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
80104600:	83 c0 01             	add    $0x1,%eax
80104603:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104607:	75 f7                	jne    80104600 <strlen+0x10>
    ;
  return n;
}
80104609:	5d                   	pop    %ebp
8010460a:	c3                   	ret    

8010460b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010460b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010460f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104613:	55                   	push   %ebp
  pushl %ebx
80104614:	53                   	push   %ebx
  pushl %esi
80104615:	56                   	push   %esi
  pushl %edi
80104616:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104617:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104619:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010461b:	5f                   	pop    %edi
  popl %esi
8010461c:	5e                   	pop    %esi
  popl %ebx
8010461d:	5b                   	pop    %ebx
  popl %ebp
8010461e:	5d                   	pop    %ebp
  ret
8010461f:	c3                   	ret    

80104620 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 04             	sub    $0x4,%esp
80104627:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010462a:	e8 a1 f0 ff ff       	call   801036d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010462f:	8b 00                	mov    (%eax),%eax
80104631:	39 d8                	cmp    %ebx,%eax
80104633:	76 1b                	jbe    80104650 <fetchint+0x30>
80104635:	8d 53 04             	lea    0x4(%ebx),%edx
80104638:	39 d0                	cmp    %edx,%eax
8010463a:	72 14                	jb     80104650 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010463c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010463f:	8b 13                	mov    (%ebx),%edx
80104641:	89 10                	mov    %edx,(%eax)
  return 0;
80104643:	31 c0                	xor    %eax,%eax
}
80104645:	83 c4 04             	add    $0x4,%esp
80104648:	5b                   	pop    %ebx
80104649:	5d                   	pop    %ebp
8010464a:	c3                   	ret    
8010464b:	90                   	nop
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104655:	eb ee                	jmp    80104645 <fetchint+0x25>
80104657:	89 f6                	mov    %esi,%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104660 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 04             	sub    $0x4,%esp
80104667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010466a:	e8 61 f0 ff ff       	call   801036d0 <myproc>

  if(addr >= curproc->sz)
8010466f:	39 18                	cmp    %ebx,(%eax)
80104671:	76 26                	jbe    80104699 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80104673:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104676:	89 da                	mov    %ebx,%edx
80104678:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010467a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010467c:	39 c3                	cmp    %eax,%ebx
8010467e:	73 19                	jae    80104699 <fetchstr+0x39>
    if(*s == 0)
80104680:	80 3b 00             	cmpb   $0x0,(%ebx)
80104683:	75 0d                	jne    80104692 <fetchstr+0x32>
80104685:	eb 21                	jmp    801046a8 <fetchstr+0x48>
80104687:	90                   	nop
80104688:	80 3a 00             	cmpb   $0x0,(%edx)
8010468b:	90                   	nop
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104690:	74 16                	je     801046a8 <fetchstr+0x48>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104692:	83 c2 01             	add    $0x1,%edx
80104695:	39 d0                	cmp    %edx,%eax
80104697:	77 ef                	ja     80104688 <fetchstr+0x28>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104699:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010469c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801046a1:	5b                   	pop    %ebx
801046a2:	5d                   	pop    %ebp
801046a3:	c3                   	ret    
801046a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046a8:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801046ab:	89 d0                	mov    %edx,%eax
801046ad:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801046af:	5b                   	pop    %ebx
801046b0:	5d                   	pop    %ebp
801046b1:	c3                   	ret    
801046b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	8b 75 0c             	mov    0xc(%ebp),%esi
801046c7:	53                   	push   %ebx
801046c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046cb:	e8 00 f0 ff ff       	call   801036d0 <myproc>
801046d0:	89 75 0c             	mov    %esi,0xc(%ebp)
801046d3:	8b 40 18             	mov    0x18(%eax),%eax
801046d6:	8b 40 44             	mov    0x44(%eax),%eax
801046d9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801046dd:	89 45 08             	mov    %eax,0x8(%ebp)
}
801046e0:	5b                   	pop    %ebx
801046e1:	5e                   	pop    %esi
801046e2:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046e3:	e9 38 ff ff ff       	jmp    80104620 <fetchint>
801046e8:	90                   	nop
801046e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	56                   	push   %esi
801046f4:	53                   	push   %ebx
801046f5:	83 ec 20             	sub    $0x20,%esp
801046f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801046fb:	e8 d0 ef ff ff       	call   801036d0 <myproc>
80104700:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104702:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104705:	89 44 24 04          	mov    %eax,0x4(%esp)
80104709:	8b 45 08             	mov    0x8(%ebp),%eax
8010470c:	89 04 24             	mov    %eax,(%esp)
8010470f:	e8 ac ff ff ff       	call   801046c0 <argint>
80104714:	85 c0                	test   %eax,%eax
80104716:	78 28                	js     80104740 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104718:	85 db                	test   %ebx,%ebx
8010471a:	78 24                	js     80104740 <argptr+0x50>
8010471c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010471f:	8b 06                	mov    (%esi),%eax
80104721:	39 c2                	cmp    %eax,%edx
80104723:	73 1b                	jae    80104740 <argptr+0x50>
80104725:	01 d3                	add    %edx,%ebx
80104727:	39 d8                	cmp    %ebx,%eax
80104729:	72 15                	jb     80104740 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010472b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010472e:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104730:	83 c4 20             	add    $0x20,%esp
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
80104733:	31 c0                	xor    %eax,%eax
}
80104735:	5b                   	pop    %ebx
80104736:	5e                   	pop    %esi
80104737:	5d                   	pop    %ebp
80104738:	c3                   	ret    
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104740:	83 c4 20             	add    $0x20,%esp
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
80104743:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}
80104748:	5b                   	pop    %ebx
80104749:	5e                   	pop    %esi
8010474a:	5d                   	pop    %ebp
8010474b:	c3                   	ret    
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104750 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104756:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104759:	89 44 24 04          	mov    %eax,0x4(%esp)
8010475d:	8b 45 08             	mov    0x8(%ebp),%eax
80104760:	89 04 24             	mov    %eax,(%esp)
80104763:	e8 58 ff ff ff       	call   801046c0 <argint>
80104768:	85 c0                	test   %eax,%eax
8010476a:	78 14                	js     80104780 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010476c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010476f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104776:	89 04 24             	mov    %eax,(%esp)
80104779:	e8 e2 fe ff ff       	call   80104660 <fetchstr>
}
8010477e:	c9                   	leave  
8010477f:	c3                   	ret    
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104785:	c9                   	leave  
80104786:	c3                   	ret    
80104787:	89 f6                	mov    %esi,%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104790 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104798:	e8 33 ef ff ff       	call   801036d0 <myproc>

  num = curproc->tf->eax;
8010479d:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801047a0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801047a2:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801047a5:	8d 50 ff             	lea    -0x1(%eax),%edx
801047a8:	83 fa 14             	cmp    $0x14,%edx
801047ab:	77 1b                	ja     801047c8 <syscall+0x38>
801047ad:	8b 14 85 00 74 10 80 	mov    -0x7fef8c00(,%eax,4),%edx
801047b4:	85 d2                	test   %edx,%edx
801047b6:	74 10                	je     801047c8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801047b8:	ff d2                	call   *%edx
801047ba:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801047bd:	83 c4 10             	add    $0x10,%esp
801047c0:	5b                   	pop    %ebx
801047c1:	5e                   	pop    %esi
801047c2:	5d                   	pop    %ebp
801047c3:	c3                   	ret    
801047c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
801047cc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801047cf:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047d3:	8b 43 10             	mov    0x10(%ebx),%eax
801047d6:	c7 04 24 d1 73 10 80 	movl   $0x801073d1,(%esp)
801047dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801047e1:	e8 6a be ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801047e6:	8b 43 18             	mov    0x18(%ebx),%eax
801047e9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801047f0:	83 c4 10             	add    $0x10,%esp
801047f3:	5b                   	pop    %ebx
801047f4:	5e                   	pop    %esi
801047f5:	5d                   	pop    %ebp
801047f6:	c3                   	ret    
801047f7:	66 90                	xchg   %ax,%ax
801047f9:	66 90                	xchg   %ax,%ax
801047fb:	66 90                	xchg   %ax,%ax
801047fd:	66 90                	xchg   %ax,%ax
801047ff:	90                   	nop

80104800 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	89 c3                	mov    %eax,%ebx
80104806:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104809:	e8 c2 ee ff ff       	call   801036d0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010480e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104810:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104814:	85 c9                	test   %ecx,%ecx
80104816:	74 18                	je     80104830 <fdalloc+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104818:	83 c2 01             	add    $0x1,%edx
8010481b:	83 fa 10             	cmp    $0x10,%edx
8010481e:	75 f0                	jne    80104810 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104820:	83 c4 04             	add    $0x4,%esp
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80104823:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104828:	5b                   	pop    %ebx
80104829:	5d                   	pop    %ebp
8010482a:	c3                   	ret    
8010482b:	90                   	nop
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104830:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
80104834:	83 c4 04             	add    $0x4,%esp
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
80104837:	89 d0                	mov    %edx,%eax
    }
  }
  return -1;
}
80104839:	5b                   	pop    %ebx
8010483a:	5d                   	pop    %ebp
8010483b:	c3                   	ret    
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	56                   	push   %esi
80104845:	53                   	push   %ebx
80104846:	83 ec 3c             	sub    $0x3c,%esp
80104849:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010484c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010484f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104852:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104856:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104859:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010485c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010485f:	e8 bc d6 ff ff       	call   80101f20 <nameiparent>
80104864:	85 c0                	test   %eax,%eax
80104866:	89 c7                	mov    %eax,%edi
80104868:	0f 84 da 00 00 00    	je     80104948 <create+0x108>
    return 0;
  ilock(dp);
8010486e:	89 04 24             	mov    %eax,(%esp)
80104871:	e8 3a ce ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104876:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010487d:	00 
8010487e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104882:	89 3c 24             	mov    %edi,(%esp)
80104885:	e8 36 d3 ff ff       	call   80101bc0 <dirlookup>
8010488a:	85 c0                	test   %eax,%eax
8010488c:	89 c6                	mov    %eax,%esi
8010488e:	74 40                	je     801048d0 <create+0x90>
    iunlockput(dp);
80104890:	89 3c 24             	mov    %edi,(%esp)
80104893:	e8 78 d0 ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80104898:	89 34 24             	mov    %esi,(%esp)
8010489b:	e8 10 ce ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801048a0:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801048a5:	75 11                	jne    801048b8 <create+0x78>
801048a7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801048ac:	89 f0                	mov    %esi,%eax
801048ae:	75 08                	jne    801048b8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048b0:	83 c4 3c             	add    $0x3c,%esp
801048b3:	5b                   	pop    %ebx
801048b4:	5e                   	pop    %esi
801048b5:	5f                   	pop    %edi
801048b6:	5d                   	pop    %ebp
801048b7:	c3                   	ret    
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801048b8:	89 34 24             	mov    %esi,(%esp)
801048bb:	e8 50 d0 ff ff       	call   80101910 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048c0:	83 c4 3c             	add    $0x3c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801048c3:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048c5:	5b                   	pop    %ebx
801048c6:	5e                   	pop    %esi
801048c7:	5f                   	pop    %edi
801048c8:	5d                   	pop    %ebp
801048c9:	c3                   	ret    
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801048d0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801048d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801048d8:	8b 07                	mov    (%edi),%eax
801048da:	89 04 24             	mov    %eax,(%esp)
801048dd:	e8 3e cc ff ff       	call   80101520 <ialloc>
801048e2:	85 c0                	test   %eax,%eax
801048e4:	89 c6                	mov    %eax,%esi
801048e6:	0f 84 bf 00 00 00    	je     801049ab <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
801048ec:	89 04 24             	mov    %eax,(%esp)
801048ef:	e8 bc cd ff ff       	call   801016b0 <ilock>
  ip->major = major;
801048f4:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801048f8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801048fc:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104900:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104904:	b8 01 00 00 00       	mov    $0x1,%eax
80104909:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010490d:	89 34 24             	mov    %esi,(%esp)
80104910:	e8 db cc ff ff       	call   801015f0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104915:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010491a:	74 34                	je     80104950 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010491c:	8b 46 04             	mov    0x4(%esi),%eax
8010491f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104923:	89 3c 24             	mov    %edi,(%esp)
80104926:	89 44 24 08          	mov    %eax,0x8(%esp)
8010492a:	e8 f1 d4 ff ff       	call   80101e20 <dirlink>
8010492f:	85 c0                	test   %eax,%eax
80104931:	78 6c                	js     8010499f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104933:	89 3c 24             	mov    %edi,(%esp)
80104936:	e8 d5 cf ff ff       	call   80101910 <iunlockput>

  return ip;
}
8010493b:	83 c4 3c             	add    $0x3c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
8010493e:	89 f0                	mov    %esi,%eax
}
80104940:	5b                   	pop    %ebx
80104941:	5e                   	pop    %esi
80104942:	5f                   	pop    %edi
80104943:	5d                   	pop    %ebp
80104944:	c3                   	ret    
80104945:	8d 76 00             	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104948:	31 c0                	xor    %eax,%eax
8010494a:	e9 61 ff ff ff       	jmp    801048b0 <create+0x70>
8010494f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104950:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104955:	89 3c 24             	mov    %edi,(%esp)
80104958:	e8 93 cc ff ff       	call   801015f0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010495d:	8b 46 04             	mov    0x4(%esi),%eax
80104960:	c7 44 24 04 74 74 10 	movl   $0x80107474,0x4(%esp)
80104967:	80 
80104968:	89 34 24             	mov    %esi,(%esp)
8010496b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010496f:	e8 ac d4 ff ff       	call   80101e20 <dirlink>
80104974:	85 c0                	test   %eax,%eax
80104976:	78 1b                	js     80104993 <create+0x153>
80104978:	8b 47 04             	mov    0x4(%edi),%eax
8010497b:	c7 44 24 04 73 74 10 	movl   $0x80107473,0x4(%esp)
80104982:	80 
80104983:	89 34 24             	mov    %esi,(%esp)
80104986:	89 44 24 08          	mov    %eax,0x8(%esp)
8010498a:	e8 91 d4 ff ff       	call   80101e20 <dirlink>
8010498f:	85 c0                	test   %eax,%eax
80104991:	79 89                	jns    8010491c <create+0xdc>
      panic("create dots");
80104993:	c7 04 24 67 74 10 80 	movl   $0x80107467,(%esp)
8010499a:	e8 c1 b9 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010499f:	c7 04 24 76 74 10 80 	movl   $0x80107476,(%esp)
801049a6:	e8 b5 b9 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801049ab:	c7 04 24 58 74 10 80 	movl   $0x80107458,(%esp)
801049b2:	e8 a9 b9 ff ff       	call   80100360 <panic>
801049b7:	89 f6                	mov    %esi,%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	89 c6                	mov    %eax,%esi
801049c6:	53                   	push   %ebx
801049c7:	89 d3                	mov    %edx,%ebx
801049c9:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801049cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801049d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049da:	e8 e1 fc ff ff       	call   801046c0 <argint>
801049df:	85 c0                	test   %eax,%eax
801049e1:	78 2d                	js     80104a10 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801049e3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801049e7:	77 27                	ja     80104a10 <argfd.constprop.0+0x50>
801049e9:	e8 e2 ec ff ff       	call   801036d0 <myproc>
801049ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049f1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801049f5:	85 c0                	test   %eax,%eax
801049f7:	74 17                	je     80104a10 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801049f9:	85 f6                	test   %esi,%esi
801049fb:	74 02                	je     801049ff <argfd.constprop.0+0x3f>
    *pfd = fd;
801049fd:	89 16                	mov    %edx,(%esi)
  if(pf)
801049ff:	85 db                	test   %ebx,%ebx
80104a01:	74 1d                	je     80104a20 <argfd.constprop.0+0x60>
    *pf = f;
80104a03:	89 03                	mov    %eax,(%ebx)
  return 0;
80104a05:	31 c0                	xor    %eax,%eax
}
80104a07:	83 c4 20             	add    $0x20,%esp
80104a0a:	5b                   	pop    %ebx
80104a0b:	5e                   	pop    %esi
80104a0c:	5d                   	pop    %ebp
80104a0d:	c3                   	ret    
80104a0e:	66 90                	xchg   %ax,%ax
80104a10:	83 c4 20             	add    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104a18:	5b                   	pop    %ebx
80104a19:	5e                   	pop    %esi
80104a1a:	5d                   	pop    %ebp
80104a1b:	c3                   	ret    
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104a20:	31 c0                	xor    %eax,%eax
80104a22:	eb e3                	jmp    80104a07 <argfd.constprop.0+0x47>
80104a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a30 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104a30:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a31:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104a33:	89 e5                	mov    %esp,%ebp
80104a35:	53                   	push   %ebx
80104a36:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a39:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a3c:	e8 7f ff ff ff       	call   801049c0 <argfd.constprop.0>
80104a41:	85 c0                	test   %eax,%eax
80104a43:	78 23                	js     80104a68 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a48:	e8 b3 fd ff ff       	call   80104800 <fdalloc>
80104a4d:	85 c0                	test   %eax,%eax
80104a4f:	89 c3                	mov    %eax,%ebx
80104a51:	78 15                	js     80104a68 <sys_dup+0x38>
    return -1;
  filedup(f);
80104a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a56:	89 04 24             	mov    %eax,(%esp)
80104a59:	e8 82 c3 ff ff       	call   80100de0 <filedup>
  return fd;
80104a5e:	89 d8                	mov    %ebx,%eax
}
80104a60:	83 c4 24             	add    $0x24,%esp
80104a63:	5b                   	pop    %ebx
80104a64:	5d                   	pop    %ebp
80104a65:	c3                   	ret    
80104a66:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a6d:	eb f1                	jmp    80104a60 <sys_dup+0x30>
80104a6f:	90                   	nop

80104a70 <sys_read>:
  return fd;
}

int
sys_read(void)
{
80104a70:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a71:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104a73:	89 e5                	mov    %esp,%ebp
80104a75:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a7b:	e8 40 ff ff ff       	call   801049c0 <argfd.constprop.0>
80104a80:	85 c0                	test   %eax,%eax
80104a82:	78 54                	js     80104ad8 <sys_read+0x68>
80104a84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a8b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a92:	e8 29 fc ff ff       	call   801046c0 <argint>
80104a97:	85 c0                	test   %eax,%eax
80104a99:	78 3d                	js     80104ad8 <sys_read+0x68>
80104a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104aa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ab0:	e8 3b fc ff ff       	call   801046f0 <argptr>
80104ab5:	85 c0                	test   %eax,%eax
80104ab7:	78 1f                	js     80104ad8 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104abc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aca:	89 04 24             	mov    %eax,(%esp)
80104acd:	e8 6e c4 ff ff       	call   80100f40 <fileread>
}
80104ad2:	c9                   	leave  
80104ad3:	c3                   	ret    
80104ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104add:	c9                   	leave  
80104ade:	c3                   	ret    
80104adf:	90                   	nop

80104ae0 <sys_write>:

int
sys_write(void)
{
80104ae0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ae1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104ae3:	89 e5                	mov    %esp,%ebp
80104ae5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ae8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104aeb:	e8 d0 fe ff ff       	call   801049c0 <argfd.constprop.0>
80104af0:	85 c0                	test   %eax,%eax
80104af2:	78 54                	js     80104b48 <sys_write+0x68>
80104af4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104af7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104afb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104b02:	e8 b9 fb ff ff       	call   801046c0 <argint>
80104b07:	85 c0                	test   %eax,%eax
80104b09:	78 3d                	js     80104b48 <sys_write+0x68>
80104b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b15:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b20:	e8 cb fb ff ff       	call   801046f0 <argptr>
80104b25:	85 c0                	test   %eax,%eax
80104b27:	78 1f                	js     80104b48 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b2c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b33:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b3a:	89 04 24             	mov    %eax,(%esp)
80104b3d:	e8 9e c4 ff ff       	call   80100fe0 <filewrite>
}
80104b42:	c9                   	leave  
80104b43:	c3                   	ret    
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104b4d:	c9                   	leave  
80104b4e:	c3                   	ret    
80104b4f:	90                   	nop

80104b50 <sys_close>:

int
sys_close(void)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104b56:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b5c:	e8 5f fe ff ff       	call   801049c0 <argfd.constprop.0>
80104b61:	85 c0                	test   %eax,%eax
80104b63:	78 23                	js     80104b88 <sys_close+0x38>
    return -1;
  myproc()->ofile[fd] = 0;
80104b65:	e8 66 eb ff ff       	call   801036d0 <myproc>
80104b6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b6d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104b74:	00 
  fileclose(f);
80104b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b78:	89 04 24             	mov    %eax,(%esp)
80104b7b:	e8 b0 c2 ff ff       	call   80100e30 <fileclose>
  return 0;
80104b80:	31 c0                	xor    %eax,%eax
}
80104b82:	c9                   	leave  
80104b83:	c3                   	ret    
80104b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104b88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104b8d:	c9                   	leave  
80104b8e:	c3                   	ret    
80104b8f:	90                   	nop

80104b90 <sys_fstat>:

int
sys_fstat(void)
{
80104b90:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b91:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104b93:	89 e5                	mov    %esp,%ebp
80104b95:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b98:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b9b:	e8 20 fe ff ff       	call   801049c0 <argfd.constprop.0>
80104ba0:	85 c0                	test   %eax,%eax
80104ba2:	78 34                	js     80104bd8 <sys_fstat+0x48>
80104ba4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ba7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104bae:	00 
80104baf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104bba:	e8 31 fb ff ff       	call   801046f0 <argptr>
80104bbf:	85 c0                	test   %eax,%eax
80104bc1:	78 15                	js     80104bd8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bcd:	89 04 24             	mov    %eax,(%esp)
80104bd0:	e8 1b c3 ff ff       	call   80100ef0 <filestat>
}
80104bd5:	c9                   	leave  
80104bd6:	c3                   	ret    
80104bd7:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104bdd:	c9                   	leave  
80104bde:	c3                   	ret    
80104bdf:	90                   	nop

80104be0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	57                   	push   %edi
80104be4:	56                   	push   %esi
80104be5:	53                   	push   %ebx
80104be6:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104be9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104bec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bf0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104bf7:	e8 54 fb ff ff       	call   80104750 <argstr>
80104bfc:	85 c0                	test   %eax,%eax
80104bfe:	0f 88 e6 00 00 00    	js     80104cea <sys_link+0x10a>
80104c04:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c12:	e8 39 fb ff ff       	call   80104750 <argstr>
80104c17:	85 c0                	test   %eax,%eax
80104c19:	0f 88 cb 00 00 00    	js     80104cea <sys_link+0x10a>
    return -1;

  begin_op();
80104c1f:	e8 ec df ff ff       	call   80102c10 <begin_op>
  if((ip = namei(old)) == 0){
80104c24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104c27:	89 04 24             	mov    %eax,(%esp)
80104c2a:	e8 d1 d2 ff ff       	call   80101f00 <namei>
80104c2f:	85 c0                	test   %eax,%eax
80104c31:	89 c3                	mov    %eax,%ebx
80104c33:	0f 84 ac 00 00 00    	je     80104ce5 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104c39:	89 04 24             	mov    %eax,(%esp)
80104c3c:	e8 6f ca ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
80104c41:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c46:	0f 84 91 00 00 00    	je     80104cdd <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104c4c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104c51:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104c54:	89 1c 24             	mov    %ebx,(%esp)
80104c57:	e8 94 c9 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
80104c5c:	89 1c 24             	mov    %ebx,(%esp)
80104c5f:	e8 2c cb ff ff       	call   80101790 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104c64:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104c67:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c6b:	89 04 24             	mov    %eax,(%esp)
80104c6e:	e8 ad d2 ff ff       	call   80101f20 <nameiparent>
80104c73:	85 c0                	test   %eax,%eax
80104c75:	89 c6                	mov    %eax,%esi
80104c77:	74 4f                	je     80104cc8 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104c79:	89 04 24             	mov    %eax,(%esp)
80104c7c:	e8 2f ca ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c81:	8b 03                	mov    (%ebx),%eax
80104c83:	39 06                	cmp    %eax,(%esi)
80104c85:	75 39                	jne    80104cc0 <sys_link+0xe0>
80104c87:	8b 43 04             	mov    0x4(%ebx),%eax
80104c8a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c8e:	89 34 24             	mov    %esi,(%esp)
80104c91:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c95:	e8 86 d1 ff ff       	call   80101e20 <dirlink>
80104c9a:	85 c0                	test   %eax,%eax
80104c9c:	78 22                	js     80104cc0 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104c9e:	89 34 24             	mov    %esi,(%esp)
80104ca1:	e8 6a cc ff ff       	call   80101910 <iunlockput>
  iput(ip);
80104ca6:	89 1c 24             	mov    %ebx,(%esp)
80104ca9:	e8 22 cb ff ff       	call   801017d0 <iput>

  end_op();
80104cae:	e8 cd df ff ff       	call   80102c80 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104cb3:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104cb6:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104cb8:	5b                   	pop    %ebx
80104cb9:	5e                   	pop    %esi
80104cba:	5f                   	pop    %edi
80104cbb:	5d                   	pop    %ebp
80104cbc:	c3                   	ret    
80104cbd:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104cc0:	89 34 24             	mov    %esi,(%esp)
80104cc3:	e8 48 cc ff ff       	call   80101910 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104cc8:	89 1c 24             	mov    %ebx,(%esp)
80104ccb:	e8 e0 c9 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80104cd0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104cd5:	89 1c 24             	mov    %ebx,(%esp)
80104cd8:	e8 13 c9 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104cdd:	89 1c 24             	mov    %ebx,(%esp)
80104ce0:	e8 2b cc ff ff       	call   80101910 <iunlockput>
  end_op();
80104ce5:	e8 96 df ff ff       	call   80102c80 <end_op>
  return -1;
}
80104cea:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104ced:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cf2:	5b                   	pop    %ebx
80104cf3:	5e                   	pop    %esi
80104cf4:	5f                   	pop    %edi
80104cf5:	5d                   	pop    %ebp
80104cf6:	c3                   	ret    
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d00 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	56                   	push   %esi
80104d05:	53                   	push   %ebx
80104d06:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104d09:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d17:	e8 34 fa ff ff       	call   80104750 <argstr>
80104d1c:	85 c0                	test   %eax,%eax
80104d1e:	0f 88 76 01 00 00    	js     80104e9a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104d24:	e8 e7 de ff ff       	call   80102c10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104d29:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104d2c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104d2f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d33:	89 04 24             	mov    %eax,(%esp)
80104d36:	e8 e5 d1 ff ff       	call   80101f20 <nameiparent>
80104d3b:	85 c0                	test   %eax,%eax
80104d3d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d40:	0f 84 4f 01 00 00    	je     80104e95 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104d46:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d49:	89 34 24             	mov    %esi,(%esp)
80104d4c:	e8 5f c9 ff ff       	call   801016b0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104d51:	c7 44 24 04 74 74 10 	movl   $0x80107474,0x4(%esp)
80104d58:	80 
80104d59:	89 1c 24             	mov    %ebx,(%esp)
80104d5c:	e8 2f ce ff ff       	call   80101b90 <namecmp>
80104d61:	85 c0                	test   %eax,%eax
80104d63:	0f 84 21 01 00 00    	je     80104e8a <sys_unlink+0x18a>
80104d69:	c7 44 24 04 73 74 10 	movl   $0x80107473,0x4(%esp)
80104d70:	80 
80104d71:	89 1c 24             	mov    %ebx,(%esp)
80104d74:	e8 17 ce ff ff       	call   80101b90 <namecmp>
80104d79:	85 c0                	test   %eax,%eax
80104d7b:	0f 84 09 01 00 00    	je     80104e8a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104d81:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d84:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d88:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d8c:	89 34 24             	mov    %esi,(%esp)
80104d8f:	e8 2c ce ff ff       	call   80101bc0 <dirlookup>
80104d94:	85 c0                	test   %eax,%eax
80104d96:	89 c3                	mov    %eax,%ebx
80104d98:	0f 84 ec 00 00 00    	je     80104e8a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104d9e:	89 04 24             	mov    %eax,(%esp)
80104da1:	e8 0a c9 ff ff       	call   801016b0 <ilock>

  if(ip->nlink < 1)
80104da6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104dab:	0f 8e 24 01 00 00    	jle    80104ed5 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104db1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104db6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104db9:	74 7d                	je     80104e38 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104dbb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104dc2:	00 
80104dc3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104dca:	00 
80104dcb:	89 34 24             	mov    %esi,(%esp)
80104dce:	e8 fd f5 ff ff       	call   801043d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104dd3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104dd6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104ddd:	00 
80104dde:	89 74 24 04          	mov    %esi,0x4(%esp)
80104de2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104de6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104de9:	89 04 24             	mov    %eax,(%esp)
80104dec:	e8 6f cc ff ff       	call   80101a60 <writei>
80104df1:	83 f8 10             	cmp    $0x10,%eax
80104df4:	0f 85 cf 00 00 00    	jne    80104ec9 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104dfa:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104dff:	0f 84 a3 00 00 00    	je     80104ea8 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104e05:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e08:	89 04 24             	mov    %eax,(%esp)
80104e0b:	e8 00 cb ff ff       	call   80101910 <iunlockput>

  ip->nlink--;
80104e10:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e15:	89 1c 24             	mov    %ebx,(%esp)
80104e18:	e8 d3 c7 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104e1d:	89 1c 24             	mov    %ebx,(%esp)
80104e20:	e8 eb ca ff ff       	call   80101910 <iunlockput>

  end_op();
80104e25:	e8 56 de ff ff       	call   80102c80 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e2a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104e2d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e2f:	5b                   	pop    %ebx
80104e30:	5e                   	pop    %esi
80104e31:	5f                   	pop    %edi
80104e32:	5d                   	pop    %ebp
80104e33:	c3                   	ret    
80104e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e38:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e3c:	0f 86 79 ff ff ff    	jbe    80104dbb <sys_unlink+0xbb>
80104e42:	bf 20 00 00 00       	mov    $0x20,%edi
80104e47:	eb 15                	jmp    80104e5e <sys_unlink+0x15e>
80104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e50:	8d 57 10             	lea    0x10(%edi),%edx
80104e53:	3b 53 58             	cmp    0x58(%ebx),%edx
80104e56:	0f 83 5f ff ff ff    	jae    80104dbb <sys_unlink+0xbb>
80104e5c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e5e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e65:	00 
80104e66:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104e6a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e6e:	89 1c 24             	mov    %ebx,(%esp)
80104e71:	e8 ea ca ff ff       	call   80101960 <readi>
80104e76:	83 f8 10             	cmp    $0x10,%eax
80104e79:	75 42                	jne    80104ebd <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104e7b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e80:	74 ce                	je     80104e50 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104e82:	89 1c 24             	mov    %ebx,(%esp)
80104e85:	e8 86 ca ff ff       	call   80101910 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104e8a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e8d:	89 04 24             	mov    %eax,(%esp)
80104e90:	e8 7b ca ff ff       	call   80101910 <iunlockput>
  end_op();
80104e95:	e8 e6 dd ff ff       	call   80102c80 <end_op>
  return -1;
}
80104e9a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ea2:	5b                   	pop    %ebx
80104ea3:	5e                   	pop    %esi
80104ea4:	5f                   	pop    %edi
80104ea5:	5d                   	pop    %ebp
80104ea6:	c3                   	ret    
80104ea7:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104ea8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104eab:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104eb0:	89 04 24             	mov    %eax,(%esp)
80104eb3:	e8 38 c7 ff ff       	call   801015f0 <iupdate>
80104eb8:	e9 48 ff ff ff       	jmp    80104e05 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104ebd:	c7 04 24 98 74 10 80 	movl   $0x80107498,(%esp)
80104ec4:	e8 97 b4 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104ec9:	c7 04 24 aa 74 10 80 	movl   $0x801074aa,(%esp)
80104ed0:	e8 8b b4 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104ed5:	c7 04 24 86 74 10 80 	movl   $0x80107486,(%esp)
80104edc:	e8 7f b4 ff ff       	call   80100360 <panic>
80104ee1:	eb 0d                	jmp    80104ef0 <sys_open>
80104ee3:	90                   	nop
80104ee4:	90                   	nop
80104ee5:	90                   	nop
80104ee6:	90                   	nop
80104ee7:	90                   	nop
80104ee8:	90                   	nop
80104ee9:	90                   	nop
80104eea:	90                   	nop
80104eeb:	90                   	nop
80104eec:	90                   	nop
80104eed:	90                   	nop
80104eee:	90                   	nop
80104eef:	90                   	nop

80104ef0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	57                   	push   %edi
80104ef4:	56                   	push   %esi
80104ef5:	53                   	push   %ebx
80104ef6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104ef9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104efc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f07:	e8 44 f8 ff ff       	call   80104750 <argstr>
80104f0c:	85 c0                	test   %eax,%eax
80104f0e:	0f 88 d1 00 00 00    	js     80104fe5 <sys_open+0xf5>
80104f14:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f17:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f1b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f22:	e8 99 f7 ff ff       	call   801046c0 <argint>
80104f27:	85 c0                	test   %eax,%eax
80104f29:	0f 88 b6 00 00 00    	js     80104fe5 <sys_open+0xf5>
    return -1;

  begin_op();
80104f2f:	e8 dc dc ff ff       	call   80102c10 <begin_op>

  if(omode & O_CREATE){
80104f34:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f38:	0f 85 82 00 00 00    	jne    80104fc0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f41:	89 04 24             	mov    %eax,(%esp)
80104f44:	e8 b7 cf ff ff       	call   80101f00 <namei>
80104f49:	85 c0                	test   %eax,%eax
80104f4b:	89 c6                	mov    %eax,%esi
80104f4d:	0f 84 8d 00 00 00    	je     80104fe0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104f53:	89 04 24             	mov    %eax,(%esp)
80104f56:	e8 55 c7 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f5b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104f60:	0f 84 92 00 00 00    	je     80104ff8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104f66:	e8 05 be ff ff       	call   80100d70 <filealloc>
80104f6b:	85 c0                	test   %eax,%eax
80104f6d:	89 c3                	mov    %eax,%ebx
80104f6f:	0f 84 93 00 00 00    	je     80105008 <sys_open+0x118>
80104f75:	e8 86 f8 ff ff       	call   80104800 <fdalloc>
80104f7a:	85 c0                	test   %eax,%eax
80104f7c:	89 c7                	mov    %eax,%edi
80104f7e:	0f 88 94 00 00 00    	js     80105018 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f84:	89 34 24             	mov    %esi,(%esp)
80104f87:	e8 04 c8 ff ff       	call   80101790 <iunlock>
  end_op();
80104f8c:	e8 ef dc ff ff       	call   80102c80 <end_op>

  f->type = FD_INODE;
80104f91:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104f9a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104f9d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104fa4:	89 c2                	mov    %eax,%edx
80104fa6:	83 e2 01             	and    $0x1,%edx
80104fa9:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104fac:	a8 03                	test   $0x3,%al
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104fae:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80104fb1:	89 f8                	mov    %edi,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104fb3:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104fb7:	83 c4 2c             	add    $0x2c,%esp
80104fba:	5b                   	pop    %ebx
80104fbb:	5e                   	pop    %esi
80104fbc:	5f                   	pop    %edi
80104fbd:	5d                   	pop    %ebp
80104fbe:	c3                   	ret    
80104fbf:	90                   	nop
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104fc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fc3:	31 c9                	xor    %ecx,%ecx
80104fc5:	ba 02 00 00 00       	mov    $0x2,%edx
80104fca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fd1:	e8 6a f8 ff ff       	call   80104840 <create>
    if(ip == 0){
80104fd6:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104fd8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104fda:	75 8a                	jne    80104f66 <sys_open+0x76>
80104fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
80104fe0:	e8 9b dc ff ff       	call   80102c80 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fe5:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fed:	5b                   	pop    %ebx
80104fee:	5e                   	pop    %esi
80104fef:	5f                   	pop    %edi
80104ff0:	5d                   	pop    %ebp
80104ff1:	c3                   	ret    
80104ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ff8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104ffb:	85 c0                	test   %eax,%eax
80104ffd:	0f 84 63 ff ff ff    	je     80104f66 <sys_open+0x76>
80105003:	90                   	nop
80105004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
80105008:	89 34 24             	mov    %esi,(%esp)
8010500b:	e8 00 c9 ff ff       	call   80101910 <iunlockput>
80105010:	eb ce                	jmp    80104fe0 <sys_open+0xf0>
80105012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105018:	89 1c 24             	mov    %ebx,(%esp)
8010501b:	e8 10 be ff ff       	call   80100e30 <fileclose>
80105020:	eb e6                	jmp    80105008 <sys_open+0x118>
80105022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105036:	e8 d5 db ff ff       	call   80102c10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010503b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010503e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105042:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105049:	e8 02 f7 ff ff       	call   80104750 <argstr>
8010504e:	85 c0                	test   %eax,%eax
80105050:	78 2e                	js     80105080 <sys_mkdir+0x50>
80105052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105055:	31 c9                	xor    %ecx,%ecx
80105057:	ba 01 00 00 00       	mov    $0x1,%edx
8010505c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105063:	e8 d8 f7 ff ff       	call   80104840 <create>
80105068:	85 c0                	test   %eax,%eax
8010506a:	74 14                	je     80105080 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010506c:	89 04 24             	mov    %eax,(%esp)
8010506f:	e8 9c c8 ff ff       	call   80101910 <iunlockput>
  end_op();
80105074:	e8 07 dc ff ff       	call   80102c80 <end_op>
  return 0;
80105079:	31 c0                	xor    %eax,%eax
}
8010507b:	c9                   	leave  
8010507c:	c3                   	ret    
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105080:	e8 fb db ff ff       	call   80102c80 <end_op>
    return -1;
80105085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010508a:	c9                   	leave  
8010508b:	c3                   	ret    
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105090 <sys_mknod>:

int
sys_mknod(void)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105096:	e8 75 db ff ff       	call   80102c10 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010509b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010509e:	89 44 24 04          	mov    %eax,0x4(%esp)
801050a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050a9:	e8 a2 f6 ff ff       	call   80104750 <argstr>
801050ae:	85 c0                	test   %eax,%eax
801050b0:	78 5e                	js     80105110 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801050b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801050b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050c0:	e8 fb f5 ff ff       	call   801046c0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801050c5:	85 c0                	test   %eax,%eax
801050c7:	78 47                	js     80105110 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801050d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801050d7:	e8 e4 f5 ff ff       	call   801046c0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801050dc:	85 c0                	test   %eax,%eax
801050de:	78 30                	js     80105110 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801050e0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050e4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801050e9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801050ed:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050f3:	e8 48 f7 ff ff       	call   80104840 <create>
801050f8:	85 c0                	test   %eax,%eax
801050fa:	74 14                	je     80105110 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801050fc:	89 04 24             	mov    %eax,(%esp)
801050ff:	e8 0c c8 ff ff       	call   80101910 <iunlockput>
  end_op();
80105104:	e8 77 db ff ff       	call   80102c80 <end_op>
  return 0;
80105109:	31 c0                	xor    %eax,%eax
}
8010510b:	c9                   	leave  
8010510c:	c3                   	ret    
8010510d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105110:	e8 6b db ff ff       	call   80102c80 <end_op>
    return -1;
80105115:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010511a:	c9                   	leave  
8010511b:	c3                   	ret    
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <sys_chdir>:

int
sys_chdir(void)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105128:	e8 a3 e5 ff ff       	call   801036d0 <myproc>
8010512d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010512f:	e8 dc da ff ff       	call   80102c10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105134:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105137:	89 44 24 04          	mov    %eax,0x4(%esp)
8010513b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105142:	e8 09 f6 ff ff       	call   80104750 <argstr>
80105147:	85 c0                	test   %eax,%eax
80105149:	78 4a                	js     80105195 <sys_chdir+0x75>
8010514b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010514e:	89 04 24             	mov    %eax,(%esp)
80105151:	e8 aa cd ff ff       	call   80101f00 <namei>
80105156:	85 c0                	test   %eax,%eax
80105158:	89 c3                	mov    %eax,%ebx
8010515a:	74 39                	je     80105195 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010515c:	89 04 24             	mov    %eax,(%esp)
8010515f:	e8 4c c5 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
80105164:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105169:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
8010516c:	75 22                	jne    80105190 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010516e:	e8 1d c6 ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
80105173:	8b 46 68             	mov    0x68(%esi),%eax
80105176:	89 04 24             	mov    %eax,(%esp)
80105179:	e8 52 c6 ff ff       	call   801017d0 <iput>
  end_op();
8010517e:	e8 fd da ff ff       	call   80102c80 <end_op>
  curproc->cwd = ip;
  return 0;
80105183:	31 c0                	xor    %eax,%eax
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
80105185:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
}
80105188:	83 c4 20             	add    $0x20,%esp
8010518b:	5b                   	pop    %ebx
8010518c:	5e                   	pop    %esi
8010518d:	5d                   	pop    %ebp
8010518e:	c3                   	ret    
8010518f:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105190:	e8 7b c7 ff ff       	call   80101910 <iunlockput>
    end_op();
80105195:	e8 e6 da ff ff       	call   80102c80 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
8010519a:	83 c4 20             	add    $0x20,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
8010519d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
801051a2:	5b                   	pop    %ebx
801051a3:	5e                   	pop    %esi
801051a4:	5d                   	pop    %ebp
801051a5:	c3                   	ret    
801051a6:	8d 76 00             	lea    0x0(%esi),%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051b0 <sys_exec>:

int
sys_exec(void)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
801051b5:	53                   	push   %ebx
801051b6:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801051bc:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801051c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801051c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051cd:	e8 7e f5 ff ff       	call   80104750 <argstr>
801051d2:	85 c0                	test   %eax,%eax
801051d4:	0f 88 84 00 00 00    	js     8010525e <sys_exec+0xae>
801051da:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801051e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801051e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051eb:	e8 d0 f4 ff ff       	call   801046c0 <argint>
801051f0:	85 c0                	test   %eax,%eax
801051f2:	78 6a                	js     8010525e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051f4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801051fa:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051fc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105203:	00 
80105204:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010520a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105211:	00 
80105212:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105218:	89 04 24             	mov    %eax,(%esp)
8010521b:	e8 b0 f1 ff ff       	call   801043d0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105220:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105226:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010522a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010522d:	89 04 24             	mov    %eax,(%esp)
80105230:	e8 eb f3 ff ff       	call   80104620 <fetchint>
80105235:	85 c0                	test   %eax,%eax
80105237:	78 25                	js     8010525e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105239:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010523f:	85 c0                	test   %eax,%eax
80105241:	74 2d                	je     80105270 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105243:	89 74 24 04          	mov    %esi,0x4(%esp)
80105247:	89 04 24             	mov    %eax,(%esp)
8010524a:	e8 11 f4 ff ff       	call   80104660 <fetchstr>
8010524f:	85 c0                	test   %eax,%eax
80105251:	78 0b                	js     8010525e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105253:	83 c3 01             	add    $0x1,%ebx
80105256:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105259:	83 fb 20             	cmp    $0x20,%ebx
8010525c:	75 c2                	jne    80105220 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010525e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105264:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105269:	5b                   	pop    %ebx
8010526a:	5e                   	pop    %esi
8010526b:	5f                   	pop    %edi
8010526c:	5d                   	pop    %ebp
8010526d:	c3                   	ret    
8010526e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105270:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105276:	89 44 24 04          	mov    %eax,0x4(%esp)
8010527a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105280:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105287:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010528b:	89 04 24             	mov    %eax,(%esp)
8010528e:	e8 0d b7 ff ff       	call   801009a0 <exec>
}
80105293:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105299:	5b                   	pop    %ebx
8010529a:	5e                   	pop    %esi
8010529b:	5f                   	pop    %edi
8010529c:	5d                   	pop    %ebp
8010529d:	c3                   	ret    
8010529e:	66 90                	xchg   %ax,%ax

801052a0 <sys_pipe>:

int
sys_pipe(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	53                   	push   %ebx
801052a4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801052a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052aa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801052b1:	00 
801052b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801052b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052bd:	e8 2e f4 ff ff       	call   801046f0 <argptr>
801052c2:	85 c0                	test   %eax,%eax
801052c4:	78 6d                	js     80105333 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801052c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052d0:	89 04 24             	mov    %eax,(%esp)
801052d3:	e8 98 df ff ff       	call   80103270 <pipealloc>
801052d8:	85 c0                	test   %eax,%eax
801052da:	78 57                	js     80105333 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801052dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052df:	e8 1c f5 ff ff       	call   80104800 <fdalloc>
801052e4:	85 c0                	test   %eax,%eax
801052e6:	89 c3                	mov    %eax,%ebx
801052e8:	78 33                	js     8010531d <sys_pipe+0x7d>
801052ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ed:	e8 0e f5 ff ff       	call   80104800 <fdalloc>
801052f2:	85 c0                	test   %eax,%eax
801052f4:	78 1a                	js     80105310 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801052f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052f9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801052fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052fe:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105301:	83 c4 24             	add    $0x24,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105304:	31 c0                	xor    %eax,%eax
}
80105306:	5b                   	pop    %ebx
80105307:	5d                   	pop    %ebp
80105308:	c3                   	ret    
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105310:	e8 bb e3 ff ff       	call   801036d0 <myproc>
80105315:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010531c:	00 
    fileclose(rf);
8010531d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105320:	89 04 24             	mov    %eax,(%esp)
80105323:	e8 08 bb ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
80105328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010532b:	89 04 24             	mov    %eax,(%esp)
8010532e:	e8 fd ba ff ff       	call   80100e30 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105333:	83 c4 24             	add    $0x24,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105336:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010533b:	5b                   	pop    %ebx
8010533c:	5d                   	pop    %ebp
8010533d:	c3                   	ret    
8010533e:	66 90                	xchg   %ax,%ax

80105340 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105343:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105344:	e9 07 e6 ff ff       	jmp    80103950 <fork>
80105349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105350 <sys_exit>:
}

int
sys_exit(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 08             	sub    $0x8,%esp
  exit();
80105356:	e8 45 e8 ff ff       	call   80103ba0 <exit>
  return 0;  // not reached
}
8010535b:	31 c0                	xor    %eax,%eax
8010535d:	c9                   	leave  
8010535e:	c3                   	ret    
8010535f:	90                   	nop

80105360 <sys_wait>:

int
sys_wait(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105363:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105364:	e9 47 ea ff ff       	jmp    80103db0 <wait>
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_kill>:
}

int
sys_kill(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105376:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105379:	89 44 24 04          	mov    %eax,0x4(%esp)
8010537d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105384:	e8 37 f3 ff ff       	call   801046c0 <argint>
80105389:	85 c0                	test   %eax,%eax
8010538b:	78 13                	js     801053a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010538d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105390:	89 04 24             	mov    %eax,(%esp)
80105393:	e8 58 eb ff ff       	call   80103ef0 <kill>
}
80105398:	c9                   	leave  
80105399:	c3                   	ret    
8010539a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801053a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801053a5:	c9                   	leave  
801053a6:	c3                   	ret    
801053a7:	89 f6                	mov    %esi,%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053b0 <sys_getpid>:

int
sys_getpid(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801053b6:	e8 15 e3 ff ff       	call   801036d0 <myproc>
801053bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801053be:	c9                   	leave  
801053bf:	c3                   	ret    

801053c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	53                   	push   %ebx
801053c4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801053c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801053ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053d5:	e8 e6 f2 ff ff       	call   801046c0 <argint>
801053da:	85 c0                	test   %eax,%eax
801053dc:	78 22                	js     80105400 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801053de:	e8 ed e2 ff ff       	call   801036d0 <myproc>
  if(growproc(n) < 0)
801053e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801053e6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801053e8:	89 14 24             	mov    %edx,(%esp)
801053eb:	e8 f0 e4 ff ff       	call   801038e0 <growproc>
801053f0:	85 c0                	test   %eax,%eax
801053f2:	78 0c                	js     80105400 <sys_sbrk+0x40>
    return -1;
  return addr;
801053f4:	89 d8                	mov    %ebx,%eax
}
801053f6:	83 c4 24             	add    $0x24,%esp
801053f9:	5b                   	pop    %ebx
801053fa:	5d                   	pop    %ebp
801053fb:	c3                   	ret    
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105405:	eb ef                	jmp    801053f6 <sys_sbrk+0x36>
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105410 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	53                   	push   %ebx
80105414:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105417:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010541a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010541e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105425:	e8 96 f2 ff ff       	call   801046c0 <argint>
8010542a:	85 c0                	test   %eax,%eax
8010542c:	78 7e                	js     801054ac <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010542e:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105435:	e8 d6 ee ff ff       	call   80104310 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010543a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010543d:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105443:	85 d2                	test   %edx,%edx
80105445:	75 29                	jne    80105470 <sys_sleep+0x60>
80105447:	eb 4f                	jmp    80105498 <sys_sleep+0x88>
80105449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105450:	c7 44 24 04 60 4c 11 	movl   $0x80114c60,0x4(%esp)
80105457:	80 
80105458:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
8010545f:	e8 9c e8 ff ff       	call   80103d00 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105464:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105469:	29 d8                	sub    %ebx,%eax
8010546b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010546e:	73 28                	jae    80105498 <sys_sleep+0x88>
    if(myproc()->killed){
80105470:	e8 5b e2 ff ff       	call   801036d0 <myproc>
80105475:	8b 40 24             	mov    0x24(%eax),%eax
80105478:	85 c0                	test   %eax,%eax
8010547a:	74 d4                	je     80105450 <sys_sleep+0x40>
      release(&tickslock);
8010547c:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105483:	e8 f8 ee ff ff       	call   80104380 <release>
      return -1;
80105488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
8010548d:	83 c4 24             	add    $0x24,%esp
80105490:	5b                   	pop    %ebx
80105491:	5d                   	pop    %ebp
80105492:	c3                   	ret    
80105493:	90                   	nop
80105494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105498:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010549f:	e8 dc ee ff ff       	call   80104380 <release>
  return 0;
}
801054a4:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
801054a7:	31 c0                	xor    %eax,%eax
}
801054a9:	5b                   	pop    %ebx
801054aa:	5d                   	pop    %ebp
801054ab:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801054ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b1:	eb da                	jmp    8010548d <sys_sleep+0x7d>
801054b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	53                   	push   %ebx
801054c4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801054c7:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801054ce:	e8 3d ee ff ff       	call   80104310 <acquire>
  xticks = ticks;
801054d3:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
801054d9:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801054e0:	e8 9b ee ff ff       	call   80104380 <release>
  return xticks;
}
801054e5:	83 c4 14             	add    $0x14,%esp
801054e8:	89 d8                	mov    %ebx,%eax
801054ea:	5b                   	pop    %ebx
801054eb:	5d                   	pop    %ebp
801054ec:	c3                   	ret    

801054ed <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801054ed:	1e                   	push   %ds
  pushl %es
801054ee:	06                   	push   %es
  pushl %fs
801054ef:	0f a0                	push   %fs
  pushl %gs
801054f1:	0f a8                	push   %gs
  pushal
801054f3:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801054f4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801054f8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801054fa:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801054fc:	54                   	push   %esp
  call trap
801054fd:	e8 de 00 00 00       	call   801055e0 <trap>
  addl $4, %esp
80105502:	83 c4 04             	add    $0x4,%esp

80105505 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105505:	61                   	popa   
  popl %gs
80105506:	0f a9                	pop    %gs
  popl %fs
80105508:	0f a1                	pop    %fs
  popl %es
8010550a:	07                   	pop    %es
  popl %ds
8010550b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010550c:	83 c4 08             	add    $0x8,%esp
  iret
8010550f:	cf                   	iret   

80105510 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105510:	31 c0                	xor    %eax,%eax
80105512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105518:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010551f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105524:	66 89 0c c5 a2 4c 11 	mov    %cx,-0x7feeb35e(,%eax,8)
8010552b:	80 
8010552c:	c6 04 c5 a4 4c 11 80 	movb   $0x0,-0x7feeb35c(,%eax,8)
80105533:	00 
80105534:	c6 04 c5 a5 4c 11 80 	movb   $0x8e,-0x7feeb35b(,%eax,8)
8010553b:	8e 
8010553c:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105543:	80 
80105544:	c1 ea 10             	shr    $0x10,%edx
80105547:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
8010554e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010554f:	83 c0 01             	add    $0x1,%eax
80105552:	3d 00 01 00 00       	cmp    $0x100,%eax
80105557:	75 bf                	jne    80105518 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105559:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010555a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010555f:	89 e5                	mov    %esp,%ebp
80105561:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105564:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105569:	c7 44 24 04 b9 74 10 	movl   $0x801074b9,0x4(%esp)
80105570:	80 
80105571:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105578:	66 89 15 a2 4e 11 80 	mov    %dx,0x80114ea2
8010557f:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
80105585:	c1 e8 10             	shr    $0x10,%eax
80105588:	c6 05 a4 4e 11 80 00 	movb   $0x0,0x80114ea4
8010558f:	c6 05 a5 4e 11 80 ef 	movb   $0xef,0x80114ea5
80105596:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6

  initlock(&tickslock, "time");
8010559c:	e8 ff eb ff ff       	call   801041a0 <initlock>
}
801055a1:	c9                   	leave  
801055a2:	c3                   	ret    
801055a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <idtinit>:

void
idtinit(void)
{
801055b0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801055b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801055b6:	89 e5                	mov    %esp,%ebp
801055b8:	83 ec 10             	sub    $0x10,%esp
801055bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801055bf:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
801055c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801055c8:	c1 e8 10             	shr    $0x10,%eax
801055cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801055cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801055d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801055d5:	c9                   	leave  
801055d6:	c3                   	ret    
801055d7:	89 f6                	mov    %esi,%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	57                   	push   %edi
801055e4:	56                   	push   %esi
801055e5:	53                   	push   %ebx
801055e6:	83 ec 3c             	sub    $0x3c,%esp
801055e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801055ec:	8b 43 30             	mov    0x30(%ebx),%eax
801055ef:	83 f8 40             	cmp    $0x40,%eax
801055f2:	0f 84 a0 01 00 00    	je     80105798 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801055f8:	83 e8 20             	sub    $0x20,%eax
801055fb:	83 f8 1f             	cmp    $0x1f,%eax
801055fe:	77 08                	ja     80105608 <trap+0x28>
80105600:	ff 24 85 60 75 10 80 	jmp    *-0x7fef8aa0(,%eax,4)
80105607:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105608:	e8 c3 e0 ff ff       	call   801036d0 <myproc>
8010560d:	85 c0                	test   %eax,%eax
8010560f:	90                   	nop
80105610:	0f 84 fa 01 00 00    	je     80105810 <trap+0x230>
80105616:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010561a:	0f 84 f0 01 00 00    	je     80105810 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105620:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105623:	8b 53 38             	mov    0x38(%ebx),%edx
80105626:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105629:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010562c:	e8 7f e0 ff ff       	call   801036b0 <cpuid>
80105631:	8b 73 30             	mov    0x30(%ebx),%esi
80105634:	89 c7                	mov    %eax,%edi
80105636:	8b 43 34             	mov    0x34(%ebx),%eax
80105639:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010563c:	e8 8f e0 ff ff       	call   801036d0 <myproc>
80105641:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105644:	e8 87 e0 ff ff       	call   801036d0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105649:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010564c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105650:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105653:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105656:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010565a:	89 54 24 18          	mov    %edx,0x18(%esp)
8010565e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105661:	83 c6 6c             	add    $0x6c,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105664:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105668:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010566c:	89 54 24 10          	mov    %edx,0x10(%esp)
80105670:	8b 40 10             	mov    0x10(%eax),%eax
80105673:	c7 04 24 1c 75 10 80 	movl   $0x8010751c,(%esp)
8010567a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010567e:	e8 cd af ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105683:	e8 48 e0 ff ff       	call   801036d0 <myproc>
80105688:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010568f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105690:	e8 3b e0 ff ff       	call   801036d0 <myproc>
80105695:	85 c0                	test   %eax,%eax
80105697:	74 0c                	je     801056a5 <trap+0xc5>
80105699:	e8 32 e0 ff ff       	call   801036d0 <myproc>
8010569e:	8b 50 24             	mov    0x24(%eax),%edx
801056a1:	85 d2                	test   %edx,%edx
801056a3:	75 4b                	jne    801056f0 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801056a5:	e8 26 e0 ff ff       	call   801036d0 <myproc>
801056aa:	85 c0                	test   %eax,%eax
801056ac:	74 0d                	je     801056bb <trap+0xdb>
801056ae:	66 90                	xchg   %ax,%ax
801056b0:	e8 1b e0 ff ff       	call   801036d0 <myproc>
801056b5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801056b9:	74 4d                	je     80105708 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056bb:	e8 10 e0 ff ff       	call   801036d0 <myproc>
801056c0:	85 c0                	test   %eax,%eax
801056c2:	74 1d                	je     801056e1 <trap+0x101>
801056c4:	e8 07 e0 ff ff       	call   801036d0 <myproc>
801056c9:	8b 40 24             	mov    0x24(%eax),%eax
801056cc:	85 c0                	test   %eax,%eax
801056ce:	74 11                	je     801056e1 <trap+0x101>
801056d0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801056d4:	83 e0 03             	and    $0x3,%eax
801056d7:	66 83 f8 03          	cmp    $0x3,%ax
801056db:	0f 84 e8 00 00 00    	je     801057c9 <trap+0x1e9>
    exit();
}
801056e1:	83 c4 3c             	add    $0x3c,%esp
801056e4:	5b                   	pop    %ebx
801056e5:	5e                   	pop    %esi
801056e6:	5f                   	pop    %edi
801056e7:	5d                   	pop    %ebp
801056e8:	c3                   	ret    
801056e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056f0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801056f4:	83 e0 03             	and    $0x3,%eax
801056f7:	66 83 f8 03          	cmp    $0x3,%ax
801056fb:	75 a8                	jne    801056a5 <trap+0xc5>
    exit();
801056fd:	e8 9e e4 ff ff       	call   80103ba0 <exit>
80105702:	eb a1                	jmp    801056a5 <trap+0xc5>
80105704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105708:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105710:	75 a9                	jne    801056bb <trap+0xdb>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105712:	e8 a9 e5 ff ff       	call   80103cc0 <yield>
80105717:	eb a2                	jmp    801056bb <trap+0xdb>
80105719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105720:	e8 8b df ff ff       	call   801036b0 <cpuid>
80105725:	85 c0                	test   %eax,%eax
80105727:	0f 84 b3 00 00 00    	je     801057e0 <trap+0x200>
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105730:	e8 4b d0 ff ff       	call   80102780 <lapiceoi>
    break;
80105735:	e9 56 ff ff ff       	jmp    80105690 <trap+0xb0>
8010573a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105740:	e8 8b ce ff ff       	call   801025d0 <kbdintr>
    lapiceoi();
80105745:	e8 36 d0 ff ff       	call   80102780 <lapiceoi>
    break;
8010574a:	e9 41 ff ff ff       	jmp    80105690 <trap+0xb0>
8010574f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105750:	e8 1b 02 00 00       	call   80105970 <uartintr>
    lapiceoi();
80105755:	e8 26 d0 ff ff       	call   80102780 <lapiceoi>
    break;
8010575a:	e9 31 ff ff ff       	jmp    80105690 <trap+0xb0>
8010575f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105760:	8b 7b 38             	mov    0x38(%ebx),%edi
80105763:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105767:	e8 44 df ff ff       	call   801036b0 <cpuid>
8010576c:	c7 04 24 c4 74 10 80 	movl   $0x801074c4,(%esp)
80105773:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105777:	89 74 24 08          	mov    %esi,0x8(%esp)
8010577b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010577f:	e8 cc ae ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105784:	e8 f7 cf ff ff       	call   80102780 <lapiceoi>
    break;
80105789:	e9 02 ff ff ff       	jmp    80105690 <trap+0xb0>
8010578e:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105790:	e8 eb c8 ff ff       	call   80102080 <ideintr>
80105795:	eb 96                	jmp    8010572d <trap+0x14d>
80105797:	90                   	nop
80105798:	90                   	nop
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801057a0:	e8 2b df ff ff       	call   801036d0 <myproc>
801057a5:	8b 70 24             	mov    0x24(%eax),%esi
801057a8:	85 f6                	test   %esi,%esi
801057aa:	75 2c                	jne    801057d8 <trap+0x1f8>
      exit();
    myproc()->tf = tf;
801057ac:	e8 1f df ff ff       	call   801036d0 <myproc>
801057b1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801057b4:	e8 d7 ef ff ff       	call   80104790 <syscall>
    if(myproc()->killed)
801057b9:	e8 12 df ff ff       	call   801036d0 <myproc>
801057be:	8b 48 24             	mov    0x24(%eax),%ecx
801057c1:	85 c9                	test   %ecx,%ecx
801057c3:	0f 84 18 ff ff ff    	je     801056e1 <trap+0x101>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801057c9:	83 c4 3c             	add    $0x3c,%esp
801057cc:	5b                   	pop    %ebx
801057cd:	5e                   	pop    %esi
801057ce:	5f                   	pop    %edi
801057cf:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801057d0:	e9 cb e3 ff ff       	jmp    80103ba0 <exit>
801057d5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801057d8:	e8 c3 e3 ff ff       	call   80103ba0 <exit>
801057dd:	eb cd                	jmp    801057ac <trap+0x1cc>
801057df:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801057e0:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801057e7:	e8 24 eb ff ff       	call   80104310 <acquire>
      ticks++;
      wakeup(&ticks);
801057ec:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801057f3:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
801057fa:	e8 91 e6 ff ff       	call   80103e90 <wakeup>
      release(&tickslock);
801057ff:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105806:	e8 75 eb ff ff       	call   80104380 <release>
8010580b:	e9 1d ff ff ff       	jmp    8010572d <trap+0x14d>
80105810:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105813:	8b 73 38             	mov    0x38(%ebx),%esi
80105816:	e8 95 de ff ff       	call   801036b0 <cpuid>
8010581b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010581f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105823:	89 44 24 08          	mov    %eax,0x8(%esp)
80105827:	8b 43 30             	mov    0x30(%ebx),%eax
8010582a:	c7 04 24 e8 74 10 80 	movl   $0x801074e8,(%esp)
80105831:	89 44 24 04          	mov    %eax,0x4(%esp)
80105835:	e8 16 ae ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
8010583a:	c7 04 24 be 74 10 80 	movl   $0x801074be,(%esp)
80105841:	e8 1a ab ff ff       	call   80100360 <panic>
80105846:	66 90                	xchg   %ax,%ax
80105848:	66 90                	xchg   %ax,%ax
8010584a:	66 90                	xchg   %ax,%ax
8010584c:	66 90                	xchg   %ax,%ax
8010584e:	66 90                	xchg   %ax,%ax

80105850 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105850:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105855:	55                   	push   %ebp
80105856:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105858:	85 c0                	test   %eax,%eax
8010585a:	74 14                	je     80105870 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010585c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105861:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105862:	a8 01                	test   $0x1,%al
80105864:	74 0a                	je     80105870 <uartgetc+0x20>
80105866:	b2 f8                	mov    $0xf8,%dl
80105868:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105869:	0f b6 c0             	movzbl %al,%eax
}
8010586c:	5d                   	pop    %ebp
8010586d:	c3                   	ret    
8010586e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105875:	5d                   	pop    %ebp
80105876:	c3                   	ret    
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105880 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105880:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105885:	85 c0                	test   %eax,%eax
80105887:	74 3f                	je     801058c8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105889:	55                   	push   %ebp
8010588a:	89 e5                	mov    %esp,%ebp
8010588c:	56                   	push   %esi
8010588d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105892:	53                   	push   %ebx
  int i;

  if(!uart)
80105893:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105898:	83 ec 10             	sub    $0x10,%esp
8010589b:	eb 14                	jmp    801058b1 <uartputc+0x31>
8010589d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
801058a0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801058a7:	e8 f4 ce ff ff       	call   801027a0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801058ac:	83 eb 01             	sub    $0x1,%ebx
801058af:	74 07                	je     801058b8 <uartputc+0x38>
801058b1:	89 f2                	mov    %esi,%edx
801058b3:	ec                   	in     (%dx),%al
801058b4:	a8 20                	test   $0x20,%al
801058b6:	74 e8                	je     801058a0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
801058b8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801058bc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801058c1:	ee                   	out    %al,(%dx)
}
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	5b                   	pop    %ebx
801058c6:	5e                   	pop    %esi
801058c7:	5d                   	pop    %ebp
801058c8:	f3 c3                	repz ret 
801058ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058d0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801058d0:	55                   	push   %ebp
801058d1:	31 c9                	xor    %ecx,%ecx
801058d3:	89 e5                	mov    %esp,%ebp
801058d5:	89 c8                	mov    %ecx,%eax
801058d7:	57                   	push   %edi
801058d8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801058dd:	56                   	push   %esi
801058de:	89 fa                	mov    %edi,%edx
801058e0:	53                   	push   %ebx
801058e1:	83 ec 1c             	sub    $0x1c,%esp
801058e4:	ee                   	out    %al,(%dx)
801058e5:	be fb 03 00 00       	mov    $0x3fb,%esi
801058ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801058ef:	89 f2                	mov    %esi,%edx
801058f1:	ee                   	out    %al,(%dx)
801058f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801058f7:	b2 f8                	mov    $0xf8,%dl
801058f9:	ee                   	out    %al,(%dx)
801058fa:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801058ff:	89 c8                	mov    %ecx,%eax
80105901:	89 da                	mov    %ebx,%edx
80105903:	ee                   	out    %al,(%dx)
80105904:	b8 03 00 00 00       	mov    $0x3,%eax
80105909:	89 f2                	mov    %esi,%edx
8010590b:	ee                   	out    %al,(%dx)
8010590c:	b2 fc                	mov    $0xfc,%dl
8010590e:	89 c8                	mov    %ecx,%eax
80105910:	ee                   	out    %al,(%dx)
80105911:	b8 01 00 00 00       	mov    $0x1,%eax
80105916:	89 da                	mov    %ebx,%edx
80105918:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105919:	b2 fd                	mov    $0xfd,%dl
8010591b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010591c:	3c ff                	cmp    $0xff,%al
8010591e:	74 42                	je     80105962 <uartinit+0x92>
    return;
  uart = 1;
80105920:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105927:	00 00 00 
8010592a:	89 fa                	mov    %edi,%edx
8010592c:	ec                   	in     (%dx),%al
8010592d:	b2 f8                	mov    $0xf8,%dl
8010592f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105930:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105937:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105938:	bb e0 75 10 80       	mov    $0x801075e0,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010593d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105944:	e8 67 c9 ff ff       	call   801022b0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105949:	b8 78 00 00 00       	mov    $0x78,%eax
8010594e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105950:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105953:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105956:	e8 25 ff ff ff       	call   80105880 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010595b:	0f be 03             	movsbl (%ebx),%eax
8010595e:	84 c0                	test   %al,%al
80105960:	75 ee                	jne    80105950 <uartinit+0x80>
    uartputc(*p);
}
80105962:	83 c4 1c             	add    $0x1c,%esp
80105965:	5b                   	pop    %ebx
80105966:	5e                   	pop    %esi
80105967:	5f                   	pop    %edi
80105968:	5d                   	pop    %ebp
80105969:	c3                   	ret    
8010596a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105970 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105976:	c7 04 24 50 58 10 80 	movl   $0x80105850,(%esp)
8010597d:	e8 2e ae ff ff       	call   801007b0 <consoleintr>
}
80105982:	c9                   	leave  
80105983:	c3                   	ret    

80105984 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105984:	6a 00                	push   $0x0
  pushl $0
80105986:	6a 00                	push   $0x0
  jmp alltraps
80105988:	e9 60 fb ff ff       	jmp    801054ed <alltraps>

8010598d <vector1>:
.globl vector1
vector1:
  pushl $0
8010598d:	6a 00                	push   $0x0
  pushl $1
8010598f:	6a 01                	push   $0x1
  jmp alltraps
80105991:	e9 57 fb ff ff       	jmp    801054ed <alltraps>

80105996 <vector2>:
.globl vector2
vector2:
  pushl $0
80105996:	6a 00                	push   $0x0
  pushl $2
80105998:	6a 02                	push   $0x2
  jmp alltraps
8010599a:	e9 4e fb ff ff       	jmp    801054ed <alltraps>

8010599f <vector3>:
.globl vector3
vector3:
  pushl $0
8010599f:	6a 00                	push   $0x0
  pushl $3
801059a1:	6a 03                	push   $0x3
  jmp alltraps
801059a3:	e9 45 fb ff ff       	jmp    801054ed <alltraps>

801059a8 <vector4>:
.globl vector4
vector4:
  pushl $0
801059a8:	6a 00                	push   $0x0
  pushl $4
801059aa:	6a 04                	push   $0x4
  jmp alltraps
801059ac:	e9 3c fb ff ff       	jmp    801054ed <alltraps>

801059b1 <vector5>:
.globl vector5
vector5:
  pushl $0
801059b1:	6a 00                	push   $0x0
  pushl $5
801059b3:	6a 05                	push   $0x5
  jmp alltraps
801059b5:	e9 33 fb ff ff       	jmp    801054ed <alltraps>

801059ba <vector6>:
.globl vector6
vector6:
  pushl $0
801059ba:	6a 00                	push   $0x0
  pushl $6
801059bc:	6a 06                	push   $0x6
  jmp alltraps
801059be:	e9 2a fb ff ff       	jmp    801054ed <alltraps>

801059c3 <vector7>:
.globl vector7
vector7:
  pushl $0
801059c3:	6a 00                	push   $0x0
  pushl $7
801059c5:	6a 07                	push   $0x7
  jmp alltraps
801059c7:	e9 21 fb ff ff       	jmp    801054ed <alltraps>

801059cc <vector8>:
.globl vector8
vector8:
  pushl $8
801059cc:	6a 08                	push   $0x8
  jmp alltraps
801059ce:	e9 1a fb ff ff       	jmp    801054ed <alltraps>

801059d3 <vector9>:
.globl vector9
vector9:
  pushl $0
801059d3:	6a 00                	push   $0x0
  pushl $9
801059d5:	6a 09                	push   $0x9
  jmp alltraps
801059d7:	e9 11 fb ff ff       	jmp    801054ed <alltraps>

801059dc <vector10>:
.globl vector10
vector10:
  pushl $10
801059dc:	6a 0a                	push   $0xa
  jmp alltraps
801059de:	e9 0a fb ff ff       	jmp    801054ed <alltraps>

801059e3 <vector11>:
.globl vector11
vector11:
  pushl $11
801059e3:	6a 0b                	push   $0xb
  jmp alltraps
801059e5:	e9 03 fb ff ff       	jmp    801054ed <alltraps>

801059ea <vector12>:
.globl vector12
vector12:
  pushl $12
801059ea:	6a 0c                	push   $0xc
  jmp alltraps
801059ec:	e9 fc fa ff ff       	jmp    801054ed <alltraps>

801059f1 <vector13>:
.globl vector13
vector13:
  pushl $13
801059f1:	6a 0d                	push   $0xd
  jmp alltraps
801059f3:	e9 f5 fa ff ff       	jmp    801054ed <alltraps>

801059f8 <vector14>:
.globl vector14
vector14:
  pushl $14
801059f8:	6a 0e                	push   $0xe
  jmp alltraps
801059fa:	e9 ee fa ff ff       	jmp    801054ed <alltraps>

801059ff <vector15>:
.globl vector15
vector15:
  pushl $0
801059ff:	6a 00                	push   $0x0
  pushl $15
80105a01:	6a 0f                	push   $0xf
  jmp alltraps
80105a03:	e9 e5 fa ff ff       	jmp    801054ed <alltraps>

80105a08 <vector16>:
.globl vector16
vector16:
  pushl $0
80105a08:	6a 00                	push   $0x0
  pushl $16
80105a0a:	6a 10                	push   $0x10
  jmp alltraps
80105a0c:	e9 dc fa ff ff       	jmp    801054ed <alltraps>

80105a11 <vector17>:
.globl vector17
vector17:
  pushl $17
80105a11:	6a 11                	push   $0x11
  jmp alltraps
80105a13:	e9 d5 fa ff ff       	jmp    801054ed <alltraps>

80105a18 <vector18>:
.globl vector18
vector18:
  pushl $0
80105a18:	6a 00                	push   $0x0
  pushl $18
80105a1a:	6a 12                	push   $0x12
  jmp alltraps
80105a1c:	e9 cc fa ff ff       	jmp    801054ed <alltraps>

80105a21 <vector19>:
.globl vector19
vector19:
  pushl $0
80105a21:	6a 00                	push   $0x0
  pushl $19
80105a23:	6a 13                	push   $0x13
  jmp alltraps
80105a25:	e9 c3 fa ff ff       	jmp    801054ed <alltraps>

80105a2a <vector20>:
.globl vector20
vector20:
  pushl $0
80105a2a:	6a 00                	push   $0x0
  pushl $20
80105a2c:	6a 14                	push   $0x14
  jmp alltraps
80105a2e:	e9 ba fa ff ff       	jmp    801054ed <alltraps>

80105a33 <vector21>:
.globl vector21
vector21:
  pushl $0
80105a33:	6a 00                	push   $0x0
  pushl $21
80105a35:	6a 15                	push   $0x15
  jmp alltraps
80105a37:	e9 b1 fa ff ff       	jmp    801054ed <alltraps>

80105a3c <vector22>:
.globl vector22
vector22:
  pushl $0
80105a3c:	6a 00                	push   $0x0
  pushl $22
80105a3e:	6a 16                	push   $0x16
  jmp alltraps
80105a40:	e9 a8 fa ff ff       	jmp    801054ed <alltraps>

80105a45 <vector23>:
.globl vector23
vector23:
  pushl $0
80105a45:	6a 00                	push   $0x0
  pushl $23
80105a47:	6a 17                	push   $0x17
  jmp alltraps
80105a49:	e9 9f fa ff ff       	jmp    801054ed <alltraps>

80105a4e <vector24>:
.globl vector24
vector24:
  pushl $0
80105a4e:	6a 00                	push   $0x0
  pushl $24
80105a50:	6a 18                	push   $0x18
  jmp alltraps
80105a52:	e9 96 fa ff ff       	jmp    801054ed <alltraps>

80105a57 <vector25>:
.globl vector25
vector25:
  pushl $0
80105a57:	6a 00                	push   $0x0
  pushl $25
80105a59:	6a 19                	push   $0x19
  jmp alltraps
80105a5b:	e9 8d fa ff ff       	jmp    801054ed <alltraps>

80105a60 <vector26>:
.globl vector26
vector26:
  pushl $0
80105a60:	6a 00                	push   $0x0
  pushl $26
80105a62:	6a 1a                	push   $0x1a
  jmp alltraps
80105a64:	e9 84 fa ff ff       	jmp    801054ed <alltraps>

80105a69 <vector27>:
.globl vector27
vector27:
  pushl $0
80105a69:	6a 00                	push   $0x0
  pushl $27
80105a6b:	6a 1b                	push   $0x1b
  jmp alltraps
80105a6d:	e9 7b fa ff ff       	jmp    801054ed <alltraps>

80105a72 <vector28>:
.globl vector28
vector28:
  pushl $0
80105a72:	6a 00                	push   $0x0
  pushl $28
80105a74:	6a 1c                	push   $0x1c
  jmp alltraps
80105a76:	e9 72 fa ff ff       	jmp    801054ed <alltraps>

80105a7b <vector29>:
.globl vector29
vector29:
  pushl $0
80105a7b:	6a 00                	push   $0x0
  pushl $29
80105a7d:	6a 1d                	push   $0x1d
  jmp alltraps
80105a7f:	e9 69 fa ff ff       	jmp    801054ed <alltraps>

80105a84 <vector30>:
.globl vector30
vector30:
  pushl $0
80105a84:	6a 00                	push   $0x0
  pushl $30
80105a86:	6a 1e                	push   $0x1e
  jmp alltraps
80105a88:	e9 60 fa ff ff       	jmp    801054ed <alltraps>

80105a8d <vector31>:
.globl vector31
vector31:
  pushl $0
80105a8d:	6a 00                	push   $0x0
  pushl $31
80105a8f:	6a 1f                	push   $0x1f
  jmp alltraps
80105a91:	e9 57 fa ff ff       	jmp    801054ed <alltraps>

80105a96 <vector32>:
.globl vector32
vector32:
  pushl $0
80105a96:	6a 00                	push   $0x0
  pushl $32
80105a98:	6a 20                	push   $0x20
  jmp alltraps
80105a9a:	e9 4e fa ff ff       	jmp    801054ed <alltraps>

80105a9f <vector33>:
.globl vector33
vector33:
  pushl $0
80105a9f:	6a 00                	push   $0x0
  pushl $33
80105aa1:	6a 21                	push   $0x21
  jmp alltraps
80105aa3:	e9 45 fa ff ff       	jmp    801054ed <alltraps>

80105aa8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105aa8:	6a 00                	push   $0x0
  pushl $34
80105aaa:	6a 22                	push   $0x22
  jmp alltraps
80105aac:	e9 3c fa ff ff       	jmp    801054ed <alltraps>

80105ab1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ab1:	6a 00                	push   $0x0
  pushl $35
80105ab3:	6a 23                	push   $0x23
  jmp alltraps
80105ab5:	e9 33 fa ff ff       	jmp    801054ed <alltraps>

80105aba <vector36>:
.globl vector36
vector36:
  pushl $0
80105aba:	6a 00                	push   $0x0
  pushl $36
80105abc:	6a 24                	push   $0x24
  jmp alltraps
80105abe:	e9 2a fa ff ff       	jmp    801054ed <alltraps>

80105ac3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ac3:	6a 00                	push   $0x0
  pushl $37
80105ac5:	6a 25                	push   $0x25
  jmp alltraps
80105ac7:	e9 21 fa ff ff       	jmp    801054ed <alltraps>

80105acc <vector38>:
.globl vector38
vector38:
  pushl $0
80105acc:	6a 00                	push   $0x0
  pushl $38
80105ace:	6a 26                	push   $0x26
  jmp alltraps
80105ad0:	e9 18 fa ff ff       	jmp    801054ed <alltraps>

80105ad5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ad5:	6a 00                	push   $0x0
  pushl $39
80105ad7:	6a 27                	push   $0x27
  jmp alltraps
80105ad9:	e9 0f fa ff ff       	jmp    801054ed <alltraps>

80105ade <vector40>:
.globl vector40
vector40:
  pushl $0
80105ade:	6a 00                	push   $0x0
  pushl $40
80105ae0:	6a 28                	push   $0x28
  jmp alltraps
80105ae2:	e9 06 fa ff ff       	jmp    801054ed <alltraps>

80105ae7 <vector41>:
.globl vector41
vector41:
  pushl $0
80105ae7:	6a 00                	push   $0x0
  pushl $41
80105ae9:	6a 29                	push   $0x29
  jmp alltraps
80105aeb:	e9 fd f9 ff ff       	jmp    801054ed <alltraps>

80105af0 <vector42>:
.globl vector42
vector42:
  pushl $0
80105af0:	6a 00                	push   $0x0
  pushl $42
80105af2:	6a 2a                	push   $0x2a
  jmp alltraps
80105af4:	e9 f4 f9 ff ff       	jmp    801054ed <alltraps>

80105af9 <vector43>:
.globl vector43
vector43:
  pushl $0
80105af9:	6a 00                	push   $0x0
  pushl $43
80105afb:	6a 2b                	push   $0x2b
  jmp alltraps
80105afd:	e9 eb f9 ff ff       	jmp    801054ed <alltraps>

80105b02 <vector44>:
.globl vector44
vector44:
  pushl $0
80105b02:	6a 00                	push   $0x0
  pushl $44
80105b04:	6a 2c                	push   $0x2c
  jmp alltraps
80105b06:	e9 e2 f9 ff ff       	jmp    801054ed <alltraps>

80105b0b <vector45>:
.globl vector45
vector45:
  pushl $0
80105b0b:	6a 00                	push   $0x0
  pushl $45
80105b0d:	6a 2d                	push   $0x2d
  jmp alltraps
80105b0f:	e9 d9 f9 ff ff       	jmp    801054ed <alltraps>

80105b14 <vector46>:
.globl vector46
vector46:
  pushl $0
80105b14:	6a 00                	push   $0x0
  pushl $46
80105b16:	6a 2e                	push   $0x2e
  jmp alltraps
80105b18:	e9 d0 f9 ff ff       	jmp    801054ed <alltraps>

80105b1d <vector47>:
.globl vector47
vector47:
  pushl $0
80105b1d:	6a 00                	push   $0x0
  pushl $47
80105b1f:	6a 2f                	push   $0x2f
  jmp alltraps
80105b21:	e9 c7 f9 ff ff       	jmp    801054ed <alltraps>

80105b26 <vector48>:
.globl vector48
vector48:
  pushl $0
80105b26:	6a 00                	push   $0x0
  pushl $48
80105b28:	6a 30                	push   $0x30
  jmp alltraps
80105b2a:	e9 be f9 ff ff       	jmp    801054ed <alltraps>

80105b2f <vector49>:
.globl vector49
vector49:
  pushl $0
80105b2f:	6a 00                	push   $0x0
  pushl $49
80105b31:	6a 31                	push   $0x31
  jmp alltraps
80105b33:	e9 b5 f9 ff ff       	jmp    801054ed <alltraps>

80105b38 <vector50>:
.globl vector50
vector50:
  pushl $0
80105b38:	6a 00                	push   $0x0
  pushl $50
80105b3a:	6a 32                	push   $0x32
  jmp alltraps
80105b3c:	e9 ac f9 ff ff       	jmp    801054ed <alltraps>

80105b41 <vector51>:
.globl vector51
vector51:
  pushl $0
80105b41:	6a 00                	push   $0x0
  pushl $51
80105b43:	6a 33                	push   $0x33
  jmp alltraps
80105b45:	e9 a3 f9 ff ff       	jmp    801054ed <alltraps>

80105b4a <vector52>:
.globl vector52
vector52:
  pushl $0
80105b4a:	6a 00                	push   $0x0
  pushl $52
80105b4c:	6a 34                	push   $0x34
  jmp alltraps
80105b4e:	e9 9a f9 ff ff       	jmp    801054ed <alltraps>

80105b53 <vector53>:
.globl vector53
vector53:
  pushl $0
80105b53:	6a 00                	push   $0x0
  pushl $53
80105b55:	6a 35                	push   $0x35
  jmp alltraps
80105b57:	e9 91 f9 ff ff       	jmp    801054ed <alltraps>

80105b5c <vector54>:
.globl vector54
vector54:
  pushl $0
80105b5c:	6a 00                	push   $0x0
  pushl $54
80105b5e:	6a 36                	push   $0x36
  jmp alltraps
80105b60:	e9 88 f9 ff ff       	jmp    801054ed <alltraps>

80105b65 <vector55>:
.globl vector55
vector55:
  pushl $0
80105b65:	6a 00                	push   $0x0
  pushl $55
80105b67:	6a 37                	push   $0x37
  jmp alltraps
80105b69:	e9 7f f9 ff ff       	jmp    801054ed <alltraps>

80105b6e <vector56>:
.globl vector56
vector56:
  pushl $0
80105b6e:	6a 00                	push   $0x0
  pushl $56
80105b70:	6a 38                	push   $0x38
  jmp alltraps
80105b72:	e9 76 f9 ff ff       	jmp    801054ed <alltraps>

80105b77 <vector57>:
.globl vector57
vector57:
  pushl $0
80105b77:	6a 00                	push   $0x0
  pushl $57
80105b79:	6a 39                	push   $0x39
  jmp alltraps
80105b7b:	e9 6d f9 ff ff       	jmp    801054ed <alltraps>

80105b80 <vector58>:
.globl vector58
vector58:
  pushl $0
80105b80:	6a 00                	push   $0x0
  pushl $58
80105b82:	6a 3a                	push   $0x3a
  jmp alltraps
80105b84:	e9 64 f9 ff ff       	jmp    801054ed <alltraps>

80105b89 <vector59>:
.globl vector59
vector59:
  pushl $0
80105b89:	6a 00                	push   $0x0
  pushl $59
80105b8b:	6a 3b                	push   $0x3b
  jmp alltraps
80105b8d:	e9 5b f9 ff ff       	jmp    801054ed <alltraps>

80105b92 <vector60>:
.globl vector60
vector60:
  pushl $0
80105b92:	6a 00                	push   $0x0
  pushl $60
80105b94:	6a 3c                	push   $0x3c
  jmp alltraps
80105b96:	e9 52 f9 ff ff       	jmp    801054ed <alltraps>

80105b9b <vector61>:
.globl vector61
vector61:
  pushl $0
80105b9b:	6a 00                	push   $0x0
  pushl $61
80105b9d:	6a 3d                	push   $0x3d
  jmp alltraps
80105b9f:	e9 49 f9 ff ff       	jmp    801054ed <alltraps>

80105ba4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ba4:	6a 00                	push   $0x0
  pushl $62
80105ba6:	6a 3e                	push   $0x3e
  jmp alltraps
80105ba8:	e9 40 f9 ff ff       	jmp    801054ed <alltraps>

80105bad <vector63>:
.globl vector63
vector63:
  pushl $0
80105bad:	6a 00                	push   $0x0
  pushl $63
80105baf:	6a 3f                	push   $0x3f
  jmp alltraps
80105bb1:	e9 37 f9 ff ff       	jmp    801054ed <alltraps>

80105bb6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105bb6:	6a 00                	push   $0x0
  pushl $64
80105bb8:	6a 40                	push   $0x40
  jmp alltraps
80105bba:	e9 2e f9 ff ff       	jmp    801054ed <alltraps>

80105bbf <vector65>:
.globl vector65
vector65:
  pushl $0
80105bbf:	6a 00                	push   $0x0
  pushl $65
80105bc1:	6a 41                	push   $0x41
  jmp alltraps
80105bc3:	e9 25 f9 ff ff       	jmp    801054ed <alltraps>

80105bc8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105bc8:	6a 00                	push   $0x0
  pushl $66
80105bca:	6a 42                	push   $0x42
  jmp alltraps
80105bcc:	e9 1c f9 ff ff       	jmp    801054ed <alltraps>

80105bd1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105bd1:	6a 00                	push   $0x0
  pushl $67
80105bd3:	6a 43                	push   $0x43
  jmp alltraps
80105bd5:	e9 13 f9 ff ff       	jmp    801054ed <alltraps>

80105bda <vector68>:
.globl vector68
vector68:
  pushl $0
80105bda:	6a 00                	push   $0x0
  pushl $68
80105bdc:	6a 44                	push   $0x44
  jmp alltraps
80105bde:	e9 0a f9 ff ff       	jmp    801054ed <alltraps>

80105be3 <vector69>:
.globl vector69
vector69:
  pushl $0
80105be3:	6a 00                	push   $0x0
  pushl $69
80105be5:	6a 45                	push   $0x45
  jmp alltraps
80105be7:	e9 01 f9 ff ff       	jmp    801054ed <alltraps>

80105bec <vector70>:
.globl vector70
vector70:
  pushl $0
80105bec:	6a 00                	push   $0x0
  pushl $70
80105bee:	6a 46                	push   $0x46
  jmp alltraps
80105bf0:	e9 f8 f8 ff ff       	jmp    801054ed <alltraps>

80105bf5 <vector71>:
.globl vector71
vector71:
  pushl $0
80105bf5:	6a 00                	push   $0x0
  pushl $71
80105bf7:	6a 47                	push   $0x47
  jmp alltraps
80105bf9:	e9 ef f8 ff ff       	jmp    801054ed <alltraps>

80105bfe <vector72>:
.globl vector72
vector72:
  pushl $0
80105bfe:	6a 00                	push   $0x0
  pushl $72
80105c00:	6a 48                	push   $0x48
  jmp alltraps
80105c02:	e9 e6 f8 ff ff       	jmp    801054ed <alltraps>

80105c07 <vector73>:
.globl vector73
vector73:
  pushl $0
80105c07:	6a 00                	push   $0x0
  pushl $73
80105c09:	6a 49                	push   $0x49
  jmp alltraps
80105c0b:	e9 dd f8 ff ff       	jmp    801054ed <alltraps>

80105c10 <vector74>:
.globl vector74
vector74:
  pushl $0
80105c10:	6a 00                	push   $0x0
  pushl $74
80105c12:	6a 4a                	push   $0x4a
  jmp alltraps
80105c14:	e9 d4 f8 ff ff       	jmp    801054ed <alltraps>

80105c19 <vector75>:
.globl vector75
vector75:
  pushl $0
80105c19:	6a 00                	push   $0x0
  pushl $75
80105c1b:	6a 4b                	push   $0x4b
  jmp alltraps
80105c1d:	e9 cb f8 ff ff       	jmp    801054ed <alltraps>

80105c22 <vector76>:
.globl vector76
vector76:
  pushl $0
80105c22:	6a 00                	push   $0x0
  pushl $76
80105c24:	6a 4c                	push   $0x4c
  jmp alltraps
80105c26:	e9 c2 f8 ff ff       	jmp    801054ed <alltraps>

80105c2b <vector77>:
.globl vector77
vector77:
  pushl $0
80105c2b:	6a 00                	push   $0x0
  pushl $77
80105c2d:	6a 4d                	push   $0x4d
  jmp alltraps
80105c2f:	e9 b9 f8 ff ff       	jmp    801054ed <alltraps>

80105c34 <vector78>:
.globl vector78
vector78:
  pushl $0
80105c34:	6a 00                	push   $0x0
  pushl $78
80105c36:	6a 4e                	push   $0x4e
  jmp alltraps
80105c38:	e9 b0 f8 ff ff       	jmp    801054ed <alltraps>

80105c3d <vector79>:
.globl vector79
vector79:
  pushl $0
80105c3d:	6a 00                	push   $0x0
  pushl $79
80105c3f:	6a 4f                	push   $0x4f
  jmp alltraps
80105c41:	e9 a7 f8 ff ff       	jmp    801054ed <alltraps>

80105c46 <vector80>:
.globl vector80
vector80:
  pushl $0
80105c46:	6a 00                	push   $0x0
  pushl $80
80105c48:	6a 50                	push   $0x50
  jmp alltraps
80105c4a:	e9 9e f8 ff ff       	jmp    801054ed <alltraps>

80105c4f <vector81>:
.globl vector81
vector81:
  pushl $0
80105c4f:	6a 00                	push   $0x0
  pushl $81
80105c51:	6a 51                	push   $0x51
  jmp alltraps
80105c53:	e9 95 f8 ff ff       	jmp    801054ed <alltraps>

80105c58 <vector82>:
.globl vector82
vector82:
  pushl $0
80105c58:	6a 00                	push   $0x0
  pushl $82
80105c5a:	6a 52                	push   $0x52
  jmp alltraps
80105c5c:	e9 8c f8 ff ff       	jmp    801054ed <alltraps>

80105c61 <vector83>:
.globl vector83
vector83:
  pushl $0
80105c61:	6a 00                	push   $0x0
  pushl $83
80105c63:	6a 53                	push   $0x53
  jmp alltraps
80105c65:	e9 83 f8 ff ff       	jmp    801054ed <alltraps>

80105c6a <vector84>:
.globl vector84
vector84:
  pushl $0
80105c6a:	6a 00                	push   $0x0
  pushl $84
80105c6c:	6a 54                	push   $0x54
  jmp alltraps
80105c6e:	e9 7a f8 ff ff       	jmp    801054ed <alltraps>

80105c73 <vector85>:
.globl vector85
vector85:
  pushl $0
80105c73:	6a 00                	push   $0x0
  pushl $85
80105c75:	6a 55                	push   $0x55
  jmp alltraps
80105c77:	e9 71 f8 ff ff       	jmp    801054ed <alltraps>

80105c7c <vector86>:
.globl vector86
vector86:
  pushl $0
80105c7c:	6a 00                	push   $0x0
  pushl $86
80105c7e:	6a 56                	push   $0x56
  jmp alltraps
80105c80:	e9 68 f8 ff ff       	jmp    801054ed <alltraps>

80105c85 <vector87>:
.globl vector87
vector87:
  pushl $0
80105c85:	6a 00                	push   $0x0
  pushl $87
80105c87:	6a 57                	push   $0x57
  jmp alltraps
80105c89:	e9 5f f8 ff ff       	jmp    801054ed <alltraps>

80105c8e <vector88>:
.globl vector88
vector88:
  pushl $0
80105c8e:	6a 00                	push   $0x0
  pushl $88
80105c90:	6a 58                	push   $0x58
  jmp alltraps
80105c92:	e9 56 f8 ff ff       	jmp    801054ed <alltraps>

80105c97 <vector89>:
.globl vector89
vector89:
  pushl $0
80105c97:	6a 00                	push   $0x0
  pushl $89
80105c99:	6a 59                	push   $0x59
  jmp alltraps
80105c9b:	e9 4d f8 ff ff       	jmp    801054ed <alltraps>

80105ca0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ca0:	6a 00                	push   $0x0
  pushl $90
80105ca2:	6a 5a                	push   $0x5a
  jmp alltraps
80105ca4:	e9 44 f8 ff ff       	jmp    801054ed <alltraps>

80105ca9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105ca9:	6a 00                	push   $0x0
  pushl $91
80105cab:	6a 5b                	push   $0x5b
  jmp alltraps
80105cad:	e9 3b f8 ff ff       	jmp    801054ed <alltraps>

80105cb2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105cb2:	6a 00                	push   $0x0
  pushl $92
80105cb4:	6a 5c                	push   $0x5c
  jmp alltraps
80105cb6:	e9 32 f8 ff ff       	jmp    801054ed <alltraps>

80105cbb <vector93>:
.globl vector93
vector93:
  pushl $0
80105cbb:	6a 00                	push   $0x0
  pushl $93
80105cbd:	6a 5d                	push   $0x5d
  jmp alltraps
80105cbf:	e9 29 f8 ff ff       	jmp    801054ed <alltraps>

80105cc4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105cc4:	6a 00                	push   $0x0
  pushl $94
80105cc6:	6a 5e                	push   $0x5e
  jmp alltraps
80105cc8:	e9 20 f8 ff ff       	jmp    801054ed <alltraps>

80105ccd <vector95>:
.globl vector95
vector95:
  pushl $0
80105ccd:	6a 00                	push   $0x0
  pushl $95
80105ccf:	6a 5f                	push   $0x5f
  jmp alltraps
80105cd1:	e9 17 f8 ff ff       	jmp    801054ed <alltraps>

80105cd6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105cd6:	6a 00                	push   $0x0
  pushl $96
80105cd8:	6a 60                	push   $0x60
  jmp alltraps
80105cda:	e9 0e f8 ff ff       	jmp    801054ed <alltraps>

80105cdf <vector97>:
.globl vector97
vector97:
  pushl $0
80105cdf:	6a 00                	push   $0x0
  pushl $97
80105ce1:	6a 61                	push   $0x61
  jmp alltraps
80105ce3:	e9 05 f8 ff ff       	jmp    801054ed <alltraps>

80105ce8 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ce8:	6a 00                	push   $0x0
  pushl $98
80105cea:	6a 62                	push   $0x62
  jmp alltraps
80105cec:	e9 fc f7 ff ff       	jmp    801054ed <alltraps>

80105cf1 <vector99>:
.globl vector99
vector99:
  pushl $0
80105cf1:	6a 00                	push   $0x0
  pushl $99
80105cf3:	6a 63                	push   $0x63
  jmp alltraps
80105cf5:	e9 f3 f7 ff ff       	jmp    801054ed <alltraps>

80105cfa <vector100>:
.globl vector100
vector100:
  pushl $0
80105cfa:	6a 00                	push   $0x0
  pushl $100
80105cfc:	6a 64                	push   $0x64
  jmp alltraps
80105cfe:	e9 ea f7 ff ff       	jmp    801054ed <alltraps>

80105d03 <vector101>:
.globl vector101
vector101:
  pushl $0
80105d03:	6a 00                	push   $0x0
  pushl $101
80105d05:	6a 65                	push   $0x65
  jmp alltraps
80105d07:	e9 e1 f7 ff ff       	jmp    801054ed <alltraps>

80105d0c <vector102>:
.globl vector102
vector102:
  pushl $0
80105d0c:	6a 00                	push   $0x0
  pushl $102
80105d0e:	6a 66                	push   $0x66
  jmp alltraps
80105d10:	e9 d8 f7 ff ff       	jmp    801054ed <alltraps>

80105d15 <vector103>:
.globl vector103
vector103:
  pushl $0
80105d15:	6a 00                	push   $0x0
  pushl $103
80105d17:	6a 67                	push   $0x67
  jmp alltraps
80105d19:	e9 cf f7 ff ff       	jmp    801054ed <alltraps>

80105d1e <vector104>:
.globl vector104
vector104:
  pushl $0
80105d1e:	6a 00                	push   $0x0
  pushl $104
80105d20:	6a 68                	push   $0x68
  jmp alltraps
80105d22:	e9 c6 f7 ff ff       	jmp    801054ed <alltraps>

80105d27 <vector105>:
.globl vector105
vector105:
  pushl $0
80105d27:	6a 00                	push   $0x0
  pushl $105
80105d29:	6a 69                	push   $0x69
  jmp alltraps
80105d2b:	e9 bd f7 ff ff       	jmp    801054ed <alltraps>

80105d30 <vector106>:
.globl vector106
vector106:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $106
80105d32:	6a 6a                	push   $0x6a
  jmp alltraps
80105d34:	e9 b4 f7 ff ff       	jmp    801054ed <alltraps>

80105d39 <vector107>:
.globl vector107
vector107:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $107
80105d3b:	6a 6b                	push   $0x6b
  jmp alltraps
80105d3d:	e9 ab f7 ff ff       	jmp    801054ed <alltraps>

80105d42 <vector108>:
.globl vector108
vector108:
  pushl $0
80105d42:	6a 00                	push   $0x0
  pushl $108
80105d44:	6a 6c                	push   $0x6c
  jmp alltraps
80105d46:	e9 a2 f7 ff ff       	jmp    801054ed <alltraps>

80105d4b <vector109>:
.globl vector109
vector109:
  pushl $0
80105d4b:	6a 00                	push   $0x0
  pushl $109
80105d4d:	6a 6d                	push   $0x6d
  jmp alltraps
80105d4f:	e9 99 f7 ff ff       	jmp    801054ed <alltraps>

80105d54 <vector110>:
.globl vector110
vector110:
  pushl $0
80105d54:	6a 00                	push   $0x0
  pushl $110
80105d56:	6a 6e                	push   $0x6e
  jmp alltraps
80105d58:	e9 90 f7 ff ff       	jmp    801054ed <alltraps>

80105d5d <vector111>:
.globl vector111
vector111:
  pushl $0
80105d5d:	6a 00                	push   $0x0
  pushl $111
80105d5f:	6a 6f                	push   $0x6f
  jmp alltraps
80105d61:	e9 87 f7 ff ff       	jmp    801054ed <alltraps>

80105d66 <vector112>:
.globl vector112
vector112:
  pushl $0
80105d66:	6a 00                	push   $0x0
  pushl $112
80105d68:	6a 70                	push   $0x70
  jmp alltraps
80105d6a:	e9 7e f7 ff ff       	jmp    801054ed <alltraps>

80105d6f <vector113>:
.globl vector113
vector113:
  pushl $0
80105d6f:	6a 00                	push   $0x0
  pushl $113
80105d71:	6a 71                	push   $0x71
  jmp alltraps
80105d73:	e9 75 f7 ff ff       	jmp    801054ed <alltraps>

80105d78 <vector114>:
.globl vector114
vector114:
  pushl $0
80105d78:	6a 00                	push   $0x0
  pushl $114
80105d7a:	6a 72                	push   $0x72
  jmp alltraps
80105d7c:	e9 6c f7 ff ff       	jmp    801054ed <alltraps>

80105d81 <vector115>:
.globl vector115
vector115:
  pushl $0
80105d81:	6a 00                	push   $0x0
  pushl $115
80105d83:	6a 73                	push   $0x73
  jmp alltraps
80105d85:	e9 63 f7 ff ff       	jmp    801054ed <alltraps>

80105d8a <vector116>:
.globl vector116
vector116:
  pushl $0
80105d8a:	6a 00                	push   $0x0
  pushl $116
80105d8c:	6a 74                	push   $0x74
  jmp alltraps
80105d8e:	e9 5a f7 ff ff       	jmp    801054ed <alltraps>

80105d93 <vector117>:
.globl vector117
vector117:
  pushl $0
80105d93:	6a 00                	push   $0x0
  pushl $117
80105d95:	6a 75                	push   $0x75
  jmp alltraps
80105d97:	e9 51 f7 ff ff       	jmp    801054ed <alltraps>

80105d9c <vector118>:
.globl vector118
vector118:
  pushl $0
80105d9c:	6a 00                	push   $0x0
  pushl $118
80105d9e:	6a 76                	push   $0x76
  jmp alltraps
80105da0:	e9 48 f7 ff ff       	jmp    801054ed <alltraps>

80105da5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105da5:	6a 00                	push   $0x0
  pushl $119
80105da7:	6a 77                	push   $0x77
  jmp alltraps
80105da9:	e9 3f f7 ff ff       	jmp    801054ed <alltraps>

80105dae <vector120>:
.globl vector120
vector120:
  pushl $0
80105dae:	6a 00                	push   $0x0
  pushl $120
80105db0:	6a 78                	push   $0x78
  jmp alltraps
80105db2:	e9 36 f7 ff ff       	jmp    801054ed <alltraps>

80105db7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105db7:	6a 00                	push   $0x0
  pushl $121
80105db9:	6a 79                	push   $0x79
  jmp alltraps
80105dbb:	e9 2d f7 ff ff       	jmp    801054ed <alltraps>

80105dc0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105dc0:	6a 00                	push   $0x0
  pushl $122
80105dc2:	6a 7a                	push   $0x7a
  jmp alltraps
80105dc4:	e9 24 f7 ff ff       	jmp    801054ed <alltraps>

80105dc9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105dc9:	6a 00                	push   $0x0
  pushl $123
80105dcb:	6a 7b                	push   $0x7b
  jmp alltraps
80105dcd:	e9 1b f7 ff ff       	jmp    801054ed <alltraps>

80105dd2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105dd2:	6a 00                	push   $0x0
  pushl $124
80105dd4:	6a 7c                	push   $0x7c
  jmp alltraps
80105dd6:	e9 12 f7 ff ff       	jmp    801054ed <alltraps>

80105ddb <vector125>:
.globl vector125
vector125:
  pushl $0
80105ddb:	6a 00                	push   $0x0
  pushl $125
80105ddd:	6a 7d                	push   $0x7d
  jmp alltraps
80105ddf:	e9 09 f7 ff ff       	jmp    801054ed <alltraps>

80105de4 <vector126>:
.globl vector126
vector126:
  pushl $0
80105de4:	6a 00                	push   $0x0
  pushl $126
80105de6:	6a 7e                	push   $0x7e
  jmp alltraps
80105de8:	e9 00 f7 ff ff       	jmp    801054ed <alltraps>

80105ded <vector127>:
.globl vector127
vector127:
  pushl $0
80105ded:	6a 00                	push   $0x0
  pushl $127
80105def:	6a 7f                	push   $0x7f
  jmp alltraps
80105df1:	e9 f7 f6 ff ff       	jmp    801054ed <alltraps>

80105df6 <vector128>:
.globl vector128
vector128:
  pushl $0
80105df6:	6a 00                	push   $0x0
  pushl $128
80105df8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105dfd:	e9 eb f6 ff ff       	jmp    801054ed <alltraps>

80105e02 <vector129>:
.globl vector129
vector129:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $129
80105e04:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105e09:	e9 df f6 ff ff       	jmp    801054ed <alltraps>

80105e0e <vector130>:
.globl vector130
vector130:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $130
80105e10:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105e15:	e9 d3 f6 ff ff       	jmp    801054ed <alltraps>

80105e1a <vector131>:
.globl vector131
vector131:
  pushl $0
80105e1a:	6a 00                	push   $0x0
  pushl $131
80105e1c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105e21:	e9 c7 f6 ff ff       	jmp    801054ed <alltraps>

80105e26 <vector132>:
.globl vector132
vector132:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $132
80105e28:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105e2d:	e9 bb f6 ff ff       	jmp    801054ed <alltraps>

80105e32 <vector133>:
.globl vector133
vector133:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $133
80105e34:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105e39:	e9 af f6 ff ff       	jmp    801054ed <alltraps>

80105e3e <vector134>:
.globl vector134
vector134:
  pushl $0
80105e3e:	6a 00                	push   $0x0
  pushl $134
80105e40:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105e45:	e9 a3 f6 ff ff       	jmp    801054ed <alltraps>

80105e4a <vector135>:
.globl vector135
vector135:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $135
80105e4c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105e51:	e9 97 f6 ff ff       	jmp    801054ed <alltraps>

80105e56 <vector136>:
.globl vector136
vector136:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $136
80105e58:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105e5d:	e9 8b f6 ff ff       	jmp    801054ed <alltraps>

80105e62 <vector137>:
.globl vector137
vector137:
  pushl $0
80105e62:	6a 00                	push   $0x0
  pushl $137
80105e64:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105e69:	e9 7f f6 ff ff       	jmp    801054ed <alltraps>

80105e6e <vector138>:
.globl vector138
vector138:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $138
80105e70:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105e75:	e9 73 f6 ff ff       	jmp    801054ed <alltraps>

80105e7a <vector139>:
.globl vector139
vector139:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $139
80105e7c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105e81:	e9 67 f6 ff ff       	jmp    801054ed <alltraps>

80105e86 <vector140>:
.globl vector140
vector140:
  pushl $0
80105e86:	6a 00                	push   $0x0
  pushl $140
80105e88:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105e8d:	e9 5b f6 ff ff       	jmp    801054ed <alltraps>

80105e92 <vector141>:
.globl vector141
vector141:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $141
80105e94:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105e99:	e9 4f f6 ff ff       	jmp    801054ed <alltraps>

80105e9e <vector142>:
.globl vector142
vector142:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $142
80105ea0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105ea5:	e9 43 f6 ff ff       	jmp    801054ed <alltraps>

80105eaa <vector143>:
.globl vector143
vector143:
  pushl $0
80105eaa:	6a 00                	push   $0x0
  pushl $143
80105eac:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105eb1:	e9 37 f6 ff ff       	jmp    801054ed <alltraps>

80105eb6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $144
80105eb8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105ebd:	e9 2b f6 ff ff       	jmp    801054ed <alltraps>

80105ec2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $145
80105ec4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105ec9:	e9 1f f6 ff ff       	jmp    801054ed <alltraps>

80105ece <vector146>:
.globl vector146
vector146:
  pushl $0
80105ece:	6a 00                	push   $0x0
  pushl $146
80105ed0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105ed5:	e9 13 f6 ff ff       	jmp    801054ed <alltraps>

80105eda <vector147>:
.globl vector147
vector147:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $147
80105edc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105ee1:	e9 07 f6 ff ff       	jmp    801054ed <alltraps>

80105ee6 <vector148>:
.globl vector148
vector148:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $148
80105ee8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105eed:	e9 fb f5 ff ff       	jmp    801054ed <alltraps>

80105ef2 <vector149>:
.globl vector149
vector149:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $149
80105ef4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105ef9:	e9 ef f5 ff ff       	jmp    801054ed <alltraps>

80105efe <vector150>:
.globl vector150
vector150:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $150
80105f00:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105f05:	e9 e3 f5 ff ff       	jmp    801054ed <alltraps>

80105f0a <vector151>:
.globl vector151
vector151:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $151
80105f0c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105f11:	e9 d7 f5 ff ff       	jmp    801054ed <alltraps>

80105f16 <vector152>:
.globl vector152
vector152:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $152
80105f18:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105f1d:	e9 cb f5 ff ff       	jmp    801054ed <alltraps>

80105f22 <vector153>:
.globl vector153
vector153:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $153
80105f24:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105f29:	e9 bf f5 ff ff       	jmp    801054ed <alltraps>

80105f2e <vector154>:
.globl vector154
vector154:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $154
80105f30:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105f35:	e9 b3 f5 ff ff       	jmp    801054ed <alltraps>

80105f3a <vector155>:
.globl vector155
vector155:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $155
80105f3c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105f41:	e9 a7 f5 ff ff       	jmp    801054ed <alltraps>

80105f46 <vector156>:
.globl vector156
vector156:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $156
80105f48:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105f4d:	e9 9b f5 ff ff       	jmp    801054ed <alltraps>

80105f52 <vector157>:
.globl vector157
vector157:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $157
80105f54:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105f59:	e9 8f f5 ff ff       	jmp    801054ed <alltraps>

80105f5e <vector158>:
.globl vector158
vector158:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $158
80105f60:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105f65:	e9 83 f5 ff ff       	jmp    801054ed <alltraps>

80105f6a <vector159>:
.globl vector159
vector159:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $159
80105f6c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105f71:	e9 77 f5 ff ff       	jmp    801054ed <alltraps>

80105f76 <vector160>:
.globl vector160
vector160:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $160
80105f78:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105f7d:	e9 6b f5 ff ff       	jmp    801054ed <alltraps>

80105f82 <vector161>:
.globl vector161
vector161:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $161
80105f84:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105f89:	e9 5f f5 ff ff       	jmp    801054ed <alltraps>

80105f8e <vector162>:
.globl vector162
vector162:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $162
80105f90:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105f95:	e9 53 f5 ff ff       	jmp    801054ed <alltraps>

80105f9a <vector163>:
.globl vector163
vector163:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $163
80105f9c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105fa1:	e9 47 f5 ff ff       	jmp    801054ed <alltraps>

80105fa6 <vector164>:
.globl vector164
vector164:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $164
80105fa8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105fad:	e9 3b f5 ff ff       	jmp    801054ed <alltraps>

80105fb2 <vector165>:
.globl vector165
vector165:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $165
80105fb4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105fb9:	e9 2f f5 ff ff       	jmp    801054ed <alltraps>

80105fbe <vector166>:
.globl vector166
vector166:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $166
80105fc0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105fc5:	e9 23 f5 ff ff       	jmp    801054ed <alltraps>

80105fca <vector167>:
.globl vector167
vector167:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $167
80105fcc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105fd1:	e9 17 f5 ff ff       	jmp    801054ed <alltraps>

80105fd6 <vector168>:
.globl vector168
vector168:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $168
80105fd8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105fdd:	e9 0b f5 ff ff       	jmp    801054ed <alltraps>

80105fe2 <vector169>:
.globl vector169
vector169:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $169
80105fe4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105fe9:	e9 ff f4 ff ff       	jmp    801054ed <alltraps>

80105fee <vector170>:
.globl vector170
vector170:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $170
80105ff0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105ff5:	e9 f3 f4 ff ff       	jmp    801054ed <alltraps>

80105ffa <vector171>:
.globl vector171
vector171:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $171
80105ffc:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106001:	e9 e7 f4 ff ff       	jmp    801054ed <alltraps>

80106006 <vector172>:
.globl vector172
vector172:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $172
80106008:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010600d:	e9 db f4 ff ff       	jmp    801054ed <alltraps>

80106012 <vector173>:
.globl vector173
vector173:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $173
80106014:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106019:	e9 cf f4 ff ff       	jmp    801054ed <alltraps>

8010601e <vector174>:
.globl vector174
vector174:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $174
80106020:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106025:	e9 c3 f4 ff ff       	jmp    801054ed <alltraps>

8010602a <vector175>:
.globl vector175
vector175:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $175
8010602c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106031:	e9 b7 f4 ff ff       	jmp    801054ed <alltraps>

80106036 <vector176>:
.globl vector176
vector176:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $176
80106038:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010603d:	e9 ab f4 ff ff       	jmp    801054ed <alltraps>

80106042 <vector177>:
.globl vector177
vector177:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $177
80106044:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106049:	e9 9f f4 ff ff       	jmp    801054ed <alltraps>

8010604e <vector178>:
.globl vector178
vector178:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $178
80106050:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106055:	e9 93 f4 ff ff       	jmp    801054ed <alltraps>

8010605a <vector179>:
.globl vector179
vector179:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $179
8010605c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106061:	e9 87 f4 ff ff       	jmp    801054ed <alltraps>

80106066 <vector180>:
.globl vector180
vector180:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $180
80106068:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010606d:	e9 7b f4 ff ff       	jmp    801054ed <alltraps>

80106072 <vector181>:
.globl vector181
vector181:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $181
80106074:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106079:	e9 6f f4 ff ff       	jmp    801054ed <alltraps>

8010607e <vector182>:
.globl vector182
vector182:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $182
80106080:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106085:	e9 63 f4 ff ff       	jmp    801054ed <alltraps>

8010608a <vector183>:
.globl vector183
vector183:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $183
8010608c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106091:	e9 57 f4 ff ff       	jmp    801054ed <alltraps>

80106096 <vector184>:
.globl vector184
vector184:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $184
80106098:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010609d:	e9 4b f4 ff ff       	jmp    801054ed <alltraps>

801060a2 <vector185>:
.globl vector185
vector185:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $185
801060a4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801060a9:	e9 3f f4 ff ff       	jmp    801054ed <alltraps>

801060ae <vector186>:
.globl vector186
vector186:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $186
801060b0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801060b5:	e9 33 f4 ff ff       	jmp    801054ed <alltraps>

801060ba <vector187>:
.globl vector187
vector187:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $187
801060bc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801060c1:	e9 27 f4 ff ff       	jmp    801054ed <alltraps>

801060c6 <vector188>:
.globl vector188
vector188:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $188
801060c8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801060cd:	e9 1b f4 ff ff       	jmp    801054ed <alltraps>

801060d2 <vector189>:
.globl vector189
vector189:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $189
801060d4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801060d9:	e9 0f f4 ff ff       	jmp    801054ed <alltraps>

801060de <vector190>:
.globl vector190
vector190:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $190
801060e0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801060e5:	e9 03 f4 ff ff       	jmp    801054ed <alltraps>

801060ea <vector191>:
.globl vector191
vector191:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $191
801060ec:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801060f1:	e9 f7 f3 ff ff       	jmp    801054ed <alltraps>

801060f6 <vector192>:
.globl vector192
vector192:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $192
801060f8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801060fd:	e9 eb f3 ff ff       	jmp    801054ed <alltraps>

80106102 <vector193>:
.globl vector193
vector193:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $193
80106104:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106109:	e9 df f3 ff ff       	jmp    801054ed <alltraps>

8010610e <vector194>:
.globl vector194
vector194:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $194
80106110:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106115:	e9 d3 f3 ff ff       	jmp    801054ed <alltraps>

8010611a <vector195>:
.globl vector195
vector195:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $195
8010611c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106121:	e9 c7 f3 ff ff       	jmp    801054ed <alltraps>

80106126 <vector196>:
.globl vector196
vector196:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $196
80106128:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010612d:	e9 bb f3 ff ff       	jmp    801054ed <alltraps>

80106132 <vector197>:
.globl vector197
vector197:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $197
80106134:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106139:	e9 af f3 ff ff       	jmp    801054ed <alltraps>

8010613e <vector198>:
.globl vector198
vector198:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $198
80106140:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106145:	e9 a3 f3 ff ff       	jmp    801054ed <alltraps>

8010614a <vector199>:
.globl vector199
vector199:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $199
8010614c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106151:	e9 97 f3 ff ff       	jmp    801054ed <alltraps>

80106156 <vector200>:
.globl vector200
vector200:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $200
80106158:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010615d:	e9 8b f3 ff ff       	jmp    801054ed <alltraps>

80106162 <vector201>:
.globl vector201
vector201:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $201
80106164:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106169:	e9 7f f3 ff ff       	jmp    801054ed <alltraps>

8010616e <vector202>:
.globl vector202
vector202:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $202
80106170:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106175:	e9 73 f3 ff ff       	jmp    801054ed <alltraps>

8010617a <vector203>:
.globl vector203
vector203:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $203
8010617c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106181:	e9 67 f3 ff ff       	jmp    801054ed <alltraps>

80106186 <vector204>:
.globl vector204
vector204:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $204
80106188:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010618d:	e9 5b f3 ff ff       	jmp    801054ed <alltraps>

80106192 <vector205>:
.globl vector205
vector205:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $205
80106194:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106199:	e9 4f f3 ff ff       	jmp    801054ed <alltraps>

8010619e <vector206>:
.globl vector206
vector206:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $206
801061a0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801061a5:	e9 43 f3 ff ff       	jmp    801054ed <alltraps>

801061aa <vector207>:
.globl vector207
vector207:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $207
801061ac:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801061b1:	e9 37 f3 ff ff       	jmp    801054ed <alltraps>

801061b6 <vector208>:
.globl vector208
vector208:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $208
801061b8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801061bd:	e9 2b f3 ff ff       	jmp    801054ed <alltraps>

801061c2 <vector209>:
.globl vector209
vector209:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $209
801061c4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801061c9:	e9 1f f3 ff ff       	jmp    801054ed <alltraps>

801061ce <vector210>:
.globl vector210
vector210:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $210
801061d0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801061d5:	e9 13 f3 ff ff       	jmp    801054ed <alltraps>

801061da <vector211>:
.globl vector211
vector211:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $211
801061dc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801061e1:	e9 07 f3 ff ff       	jmp    801054ed <alltraps>

801061e6 <vector212>:
.globl vector212
vector212:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $212
801061e8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801061ed:	e9 fb f2 ff ff       	jmp    801054ed <alltraps>

801061f2 <vector213>:
.globl vector213
vector213:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $213
801061f4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801061f9:	e9 ef f2 ff ff       	jmp    801054ed <alltraps>

801061fe <vector214>:
.globl vector214
vector214:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $214
80106200:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106205:	e9 e3 f2 ff ff       	jmp    801054ed <alltraps>

8010620a <vector215>:
.globl vector215
vector215:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $215
8010620c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106211:	e9 d7 f2 ff ff       	jmp    801054ed <alltraps>

80106216 <vector216>:
.globl vector216
vector216:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $216
80106218:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010621d:	e9 cb f2 ff ff       	jmp    801054ed <alltraps>

80106222 <vector217>:
.globl vector217
vector217:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $217
80106224:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106229:	e9 bf f2 ff ff       	jmp    801054ed <alltraps>

8010622e <vector218>:
.globl vector218
vector218:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $218
80106230:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106235:	e9 b3 f2 ff ff       	jmp    801054ed <alltraps>

8010623a <vector219>:
.globl vector219
vector219:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $219
8010623c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106241:	e9 a7 f2 ff ff       	jmp    801054ed <alltraps>

80106246 <vector220>:
.globl vector220
vector220:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $220
80106248:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010624d:	e9 9b f2 ff ff       	jmp    801054ed <alltraps>

80106252 <vector221>:
.globl vector221
vector221:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $221
80106254:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106259:	e9 8f f2 ff ff       	jmp    801054ed <alltraps>

8010625e <vector222>:
.globl vector222
vector222:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $222
80106260:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106265:	e9 83 f2 ff ff       	jmp    801054ed <alltraps>

8010626a <vector223>:
.globl vector223
vector223:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $223
8010626c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106271:	e9 77 f2 ff ff       	jmp    801054ed <alltraps>

80106276 <vector224>:
.globl vector224
vector224:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $224
80106278:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010627d:	e9 6b f2 ff ff       	jmp    801054ed <alltraps>

80106282 <vector225>:
.globl vector225
vector225:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $225
80106284:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106289:	e9 5f f2 ff ff       	jmp    801054ed <alltraps>

8010628e <vector226>:
.globl vector226
vector226:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $226
80106290:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106295:	e9 53 f2 ff ff       	jmp    801054ed <alltraps>

8010629a <vector227>:
.globl vector227
vector227:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $227
8010629c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801062a1:	e9 47 f2 ff ff       	jmp    801054ed <alltraps>

801062a6 <vector228>:
.globl vector228
vector228:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $228
801062a8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801062ad:	e9 3b f2 ff ff       	jmp    801054ed <alltraps>

801062b2 <vector229>:
.globl vector229
vector229:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $229
801062b4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801062b9:	e9 2f f2 ff ff       	jmp    801054ed <alltraps>

801062be <vector230>:
.globl vector230
vector230:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $230
801062c0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801062c5:	e9 23 f2 ff ff       	jmp    801054ed <alltraps>

801062ca <vector231>:
.globl vector231
vector231:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $231
801062cc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801062d1:	e9 17 f2 ff ff       	jmp    801054ed <alltraps>

801062d6 <vector232>:
.globl vector232
vector232:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $232
801062d8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801062dd:	e9 0b f2 ff ff       	jmp    801054ed <alltraps>

801062e2 <vector233>:
.globl vector233
vector233:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $233
801062e4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801062e9:	e9 ff f1 ff ff       	jmp    801054ed <alltraps>

801062ee <vector234>:
.globl vector234
vector234:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $234
801062f0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801062f5:	e9 f3 f1 ff ff       	jmp    801054ed <alltraps>

801062fa <vector235>:
.globl vector235
vector235:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $235
801062fc:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106301:	e9 e7 f1 ff ff       	jmp    801054ed <alltraps>

80106306 <vector236>:
.globl vector236
vector236:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $236
80106308:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010630d:	e9 db f1 ff ff       	jmp    801054ed <alltraps>

80106312 <vector237>:
.globl vector237
vector237:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $237
80106314:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106319:	e9 cf f1 ff ff       	jmp    801054ed <alltraps>

8010631e <vector238>:
.globl vector238
vector238:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $238
80106320:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106325:	e9 c3 f1 ff ff       	jmp    801054ed <alltraps>

8010632a <vector239>:
.globl vector239
vector239:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $239
8010632c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106331:	e9 b7 f1 ff ff       	jmp    801054ed <alltraps>

80106336 <vector240>:
.globl vector240
vector240:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $240
80106338:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010633d:	e9 ab f1 ff ff       	jmp    801054ed <alltraps>

80106342 <vector241>:
.globl vector241
vector241:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $241
80106344:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106349:	e9 9f f1 ff ff       	jmp    801054ed <alltraps>

8010634e <vector242>:
.globl vector242
vector242:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $242
80106350:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106355:	e9 93 f1 ff ff       	jmp    801054ed <alltraps>

8010635a <vector243>:
.globl vector243
vector243:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $243
8010635c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106361:	e9 87 f1 ff ff       	jmp    801054ed <alltraps>

80106366 <vector244>:
.globl vector244
vector244:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $244
80106368:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010636d:	e9 7b f1 ff ff       	jmp    801054ed <alltraps>

80106372 <vector245>:
.globl vector245
vector245:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $245
80106374:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106379:	e9 6f f1 ff ff       	jmp    801054ed <alltraps>

8010637e <vector246>:
.globl vector246
vector246:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $246
80106380:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106385:	e9 63 f1 ff ff       	jmp    801054ed <alltraps>

8010638a <vector247>:
.globl vector247
vector247:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $247
8010638c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106391:	e9 57 f1 ff ff       	jmp    801054ed <alltraps>

80106396 <vector248>:
.globl vector248
vector248:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $248
80106398:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010639d:	e9 4b f1 ff ff       	jmp    801054ed <alltraps>

801063a2 <vector249>:
.globl vector249
vector249:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $249
801063a4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801063a9:	e9 3f f1 ff ff       	jmp    801054ed <alltraps>

801063ae <vector250>:
.globl vector250
vector250:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $250
801063b0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801063b5:	e9 33 f1 ff ff       	jmp    801054ed <alltraps>

801063ba <vector251>:
.globl vector251
vector251:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $251
801063bc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801063c1:	e9 27 f1 ff ff       	jmp    801054ed <alltraps>

801063c6 <vector252>:
.globl vector252
vector252:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $252
801063c8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801063cd:	e9 1b f1 ff ff       	jmp    801054ed <alltraps>

801063d2 <vector253>:
.globl vector253
vector253:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $253
801063d4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801063d9:	e9 0f f1 ff ff       	jmp    801054ed <alltraps>

801063de <vector254>:
.globl vector254
vector254:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $254
801063e0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801063e5:	e9 03 f1 ff ff       	jmp    801054ed <alltraps>

801063ea <vector255>:
.globl vector255
vector255:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $255
801063ec:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801063f1:	e9 f7 f0 ff ff       	jmp    801054ed <alltraps>
801063f6:	66 90                	xchg   %ax,%ax
801063f8:	66 90                	xchg   %ax,%ax
801063fa:	66 90                	xchg   %ax,%ax
801063fc:	66 90                	xchg   %ax,%ax
801063fe:	66 90                	xchg   %ax,%ax

80106400 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	57                   	push   %edi
80106404:	56                   	push   %esi
80106405:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106407:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010640a:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010640b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010640e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106411:	8b 1f                	mov    (%edi),%ebx
80106413:	f6 c3 01             	test   $0x1,%bl
80106416:	74 28                	je     80106440 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106418:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010641e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106424:	c1 ee 0a             	shr    $0xa,%esi
}
80106427:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010642a:	89 f2                	mov    %esi,%edx
8010642c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106432:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106435:	5b                   	pop    %ebx
80106436:	5e                   	pop    %esi
80106437:	5f                   	pop    %edi
80106438:	5d                   	pop    %ebp
80106439:	c3                   	ret    
8010643a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106440:	85 c9                	test   %ecx,%ecx
80106442:	74 34                	je     80106478 <walkpgdir+0x78>
80106444:	e8 57 c0 ff ff       	call   801024a0 <kalloc>
80106449:	85 c0                	test   %eax,%eax
8010644b:	89 c3                	mov    %eax,%ebx
8010644d:	74 29                	je     80106478 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010644f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106456:	00 
80106457:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010645e:	00 
8010645f:	89 04 24             	mov    %eax,(%esp)
80106462:	e8 69 df ff ff       	call   801043d0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106467:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010646d:	83 c8 07             	or     $0x7,%eax
80106470:	89 07                	mov    %eax,(%edi)
80106472:	eb b0                	jmp    80106424 <walkpgdir+0x24>
80106474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
80106478:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
8010647b:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
8010647d:	5b                   	pop    %ebx
8010647e:	5e                   	pop    %esi
8010647f:	5f                   	pop    %edi
80106480:	5d                   	pop    %ebp
80106481:	c3                   	ret    
80106482:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106490 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	57                   	push   %edi
80106494:	56                   	push   %esi
80106495:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106496:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106498:	83 ec 1c             	sub    $0x1c,%esp
8010649b:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010649e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801064a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801064a7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801064ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801064ae:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801064b2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801064b9:	29 df                	sub    %ebx,%edi
801064bb:	eb 18                	jmp    801064d5 <mappages+0x45>
801064bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801064c0:	f6 00 01             	testb  $0x1,(%eax)
801064c3:	75 3d                	jne    80106502 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
801064c5:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
801064c8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801064cb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801064cd:	74 29                	je     801064f8 <mappages+0x68>
      break;
    a += PGSIZE;
801064cf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801064d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801064d8:	b9 01 00 00 00       	mov    $0x1,%ecx
801064dd:	89 da                	mov    %ebx,%edx
801064df:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801064e2:	e8 19 ff ff ff       	call   80106400 <walkpgdir>
801064e7:	85 c0                	test   %eax,%eax
801064e9:	75 d5                	jne    801064c0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801064eb:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801064ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801064f3:	5b                   	pop    %ebx
801064f4:	5e                   	pop    %esi
801064f5:	5f                   	pop    %edi
801064f6:	5d                   	pop    %ebp
801064f7:	c3                   	ret    
801064f8:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801064fb:	31 c0                	xor    %eax,%eax
}
801064fd:	5b                   	pop    %ebx
801064fe:	5e                   	pop    %esi
801064ff:	5f                   	pop    %edi
80106500:	5d                   	pop    %ebp
80106501:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106502:	c7 04 24 e8 75 10 80 	movl   $0x801075e8,(%esp)
80106509:	e8 52 9e ff ff       	call   80100360 <panic>
8010650e:	66 90                	xchg   %ax,%ax

80106510 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	57                   	push   %edi
80106514:	89 c7                	mov    %eax,%edi
80106516:	56                   	push   %esi
80106517:	89 d6                	mov    %edx,%esi
80106519:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010651a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106520:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106523:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106529:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010652b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010652e:	72 3b                	jb     8010656b <deallocuvm.part.0+0x5b>
80106530:	eb 5e                	jmp    80106590 <deallocuvm.part.0+0x80>
80106532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106538:	8b 10                	mov    (%eax),%edx
8010653a:	f6 c2 01             	test   $0x1,%dl
8010653d:	74 22                	je     80106561 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010653f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106545:	74 54                	je     8010659b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106547:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010654d:	89 14 24             	mov    %edx,(%esp)
80106550:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106553:	e8 98 bd ff ff       	call   801022f0 <kfree>
      *pte = 0;
80106558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010655b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106561:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106567:	39 f3                	cmp    %esi,%ebx
80106569:	73 25                	jae    80106590 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010656b:	31 c9                	xor    %ecx,%ecx
8010656d:	89 da                	mov    %ebx,%edx
8010656f:	89 f8                	mov    %edi,%eax
80106571:	e8 8a fe ff ff       	call   80106400 <walkpgdir>
    if(!pte)
80106576:	85 c0                	test   %eax,%eax
80106578:	75 be                	jne    80106538 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010657a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106580:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106586:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010658c:	39 f3                	cmp    %esi,%ebx
8010658e:	72 db                	jb     8010656b <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106590:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106593:	83 c4 1c             	add    $0x1c,%esp
80106596:	5b                   	pop    %ebx
80106597:	5e                   	pop    %esi
80106598:	5f                   	pop    %edi
80106599:	5d                   	pop    %ebp
8010659a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010659b:	c7 04 24 86 6f 10 80 	movl   $0x80106f86,(%esp)
801065a2:	e8 b9 9d ff ff       	call   80100360 <panic>
801065a7:	89 f6                	mov    %esi,%esi
801065a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065b0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801065b6:	e8 f5 d0 ff ff       	call   801036b0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065bb:	31 c9                	xor    %ecx,%ecx
801065bd:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801065c2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801065c8:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065cd:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065d1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
801065d6:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065d9:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065dd:	31 c9                	xor    %ecx,%ecx
801065df:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065e3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065e8:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065ec:	31 c9                	xor    %ecx,%ecx
801065ee:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065f2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065f7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065fb:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065fd:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106601:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106605:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106609:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010660d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106611:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106615:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106619:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010661d:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106621:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106626:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010662a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010662e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106632:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106636:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010663a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010663e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106642:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106646:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010664a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010664e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106652:	c1 e8 10             	shr    $0x10,%eax
80106655:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106659:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010665c:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
8010665f:	c9                   	leave  
80106660:	c3                   	ret    
80106661:	eb 0d                	jmp    80106670 <switchkvm>
80106663:	90                   	nop
80106664:	90                   	nop
80106665:	90                   	nop
80106666:	90                   	nop
80106667:	90                   	nop
80106668:	90                   	nop
80106669:	90                   	nop
8010666a:	90                   	nop
8010666b:	90                   	nop
8010666c:	90                   	nop
8010666d:	90                   	nop
8010666e:	90                   	nop
8010666f:	90                   	nop

80106670 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106670:	a1 a4 54 11 80       	mov    0x801154a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106675:	55                   	push   %ebp
80106676:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106678:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010667d:	0f 22 d8             	mov    %eax,%cr3
}
80106680:	5d                   	pop    %ebp
80106681:	c3                   	ret    
80106682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106690 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106690:	55                   	push   %ebp
80106691:	89 e5                	mov    %esp,%ebp
80106693:	57                   	push   %edi
80106694:	56                   	push   %esi
80106695:	53                   	push   %ebx
80106696:	83 ec 1c             	sub    $0x1c,%esp
80106699:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010669c:	85 f6                	test   %esi,%esi
8010669e:	0f 84 cd 00 00 00    	je     80106771 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801066a4:	8b 46 08             	mov    0x8(%esi),%eax
801066a7:	85 c0                	test   %eax,%eax
801066a9:	0f 84 da 00 00 00    	je     80106789 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801066af:	8b 7e 04             	mov    0x4(%esi),%edi
801066b2:	85 ff                	test   %edi,%edi
801066b4:	0f 84 c3 00 00 00    	je     8010677d <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
801066ba:	e8 61 db ff ff       	call   80104220 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801066bf:	e8 6c cf ff ff       	call   80103630 <mycpu>
801066c4:	89 c3                	mov    %eax,%ebx
801066c6:	e8 65 cf ff ff       	call   80103630 <mycpu>
801066cb:	89 c7                	mov    %eax,%edi
801066cd:	e8 5e cf ff ff       	call   80103630 <mycpu>
801066d2:	83 c7 08             	add    $0x8,%edi
801066d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066d8:	e8 53 cf ff ff       	call   80103630 <mycpu>
801066dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801066e0:	ba 67 00 00 00       	mov    $0x67,%edx
801066e5:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801066ec:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801066f3:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801066fa:	83 c1 08             	add    $0x8,%ecx
801066fd:	c1 e9 10             	shr    $0x10,%ecx
80106700:	83 c0 08             	add    $0x8,%eax
80106703:	c1 e8 18             	shr    $0x18,%eax
80106706:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010670c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106713:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106719:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010671e:	e8 0d cf ff ff       	call   80103630 <mycpu>
80106723:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010672a:	e8 01 cf ff ff       	call   80103630 <mycpu>
8010672f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106734:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106738:	e8 f3 ce ff ff       	call   80103630 <mycpu>
8010673d:	8b 56 08             	mov    0x8(%esi),%edx
80106740:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106746:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106749:	e8 e2 ce ff ff       	call   80103630 <mycpu>
8010674e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106752:	b8 28 00 00 00       	mov    $0x28,%eax
80106757:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010675a:	8b 46 04             	mov    0x4(%esi),%eax
8010675d:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106762:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106765:	83 c4 1c             	add    $0x1c,%esp
80106768:	5b                   	pop    %ebx
80106769:	5e                   	pop    %esi
8010676a:	5f                   	pop    %edi
8010676b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010676c:	e9 ef da ff ff       	jmp    80104260 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106771:	c7 04 24 ee 75 10 80 	movl   $0x801075ee,(%esp)
80106778:	e8 e3 9b ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010677d:	c7 04 24 19 76 10 80 	movl   $0x80107619,(%esp)
80106784:	e8 d7 9b ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106789:	c7 04 24 04 76 10 80 	movl   $0x80107604,(%esp)
80106790:	e8 cb 9b ff ff       	call   80100360 <panic>
80106795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067a0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801067a0:	55                   	push   %ebp
801067a1:	89 e5                	mov    %esp,%ebp
801067a3:	57                   	push   %edi
801067a4:	56                   	push   %esi
801067a5:	53                   	push   %ebx
801067a6:	83 ec 1c             	sub    $0x1c,%esp
801067a9:	8b 75 10             	mov    0x10(%ebp),%esi
801067ac:	8b 45 08             	mov    0x8(%ebp),%eax
801067af:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801067b2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801067b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801067bb:	77 54                	ja     80106811 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
801067bd:	e8 de bc ff ff       	call   801024a0 <kalloc>
  memset(mem, 0, PGSIZE);
801067c2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801067c9:	00 
801067ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067d1:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801067d2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801067d4:	89 04 24             	mov    %eax,(%esp)
801067d7:	e8 f4 db ff ff       	call   801043d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801067dc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801067e2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801067e7:	89 04 24             	mov    %eax,(%esp)
801067ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ed:	31 d2                	xor    %edx,%edx
801067ef:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801067f6:	00 
801067f7:	e8 94 fc ff ff       	call   80106490 <mappages>
  memmove(mem, init, sz);
801067fc:	89 75 10             	mov    %esi,0x10(%ebp)
801067ff:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106802:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106805:	83 c4 1c             	add    $0x1c,%esp
80106808:	5b                   	pop    %ebx
80106809:	5e                   	pop    %esi
8010680a:	5f                   	pop    %edi
8010680b:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
8010680c:	e9 5f dc ff ff       	jmp    80104470 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106811:	c7 04 24 2d 76 10 80 	movl   $0x8010762d,(%esp)
80106818:	e8 43 9b ff ff       	call   80100360 <panic>
8010681d:	8d 76 00             	lea    0x0(%esi),%esi

80106820 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	57                   	push   %edi
80106824:	56                   	push   %esi
80106825:	53                   	push   %ebx
80106826:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106829:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106830:	0f 85 98 00 00 00    	jne    801068ce <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106836:	8b 75 18             	mov    0x18(%ebp),%esi
80106839:	31 db                	xor    %ebx,%ebx
8010683b:	85 f6                	test   %esi,%esi
8010683d:	75 1a                	jne    80106859 <loaduvm+0x39>
8010683f:	eb 77                	jmp    801068b8 <loaduvm+0x98>
80106841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106848:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010684e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106854:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106857:	76 5f                	jbe    801068b8 <loaduvm+0x98>
80106859:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010685c:	31 c9                	xor    %ecx,%ecx
8010685e:	8b 45 08             	mov    0x8(%ebp),%eax
80106861:	01 da                	add    %ebx,%edx
80106863:	e8 98 fb ff ff       	call   80106400 <walkpgdir>
80106868:	85 c0                	test   %eax,%eax
8010686a:	74 56                	je     801068c2 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010686c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010686e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106873:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106876:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010687b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106881:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106884:	05 00 00 00 80       	add    $0x80000000,%eax
80106889:	89 44 24 04          	mov    %eax,0x4(%esp)
8010688d:	8b 45 10             	mov    0x10(%ebp),%eax
80106890:	01 d9                	add    %ebx,%ecx
80106892:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106896:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010689a:	89 04 24             	mov    %eax,(%esp)
8010689d:	e8 be b0 ff ff       	call   80101960 <readi>
801068a2:	39 f8                	cmp    %edi,%eax
801068a4:	74 a2                	je     80106848 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801068a6:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
801068a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801068ae:	5b                   	pop    %ebx
801068af:	5e                   	pop    %esi
801068b0:	5f                   	pop    %edi
801068b1:	5d                   	pop    %ebp
801068b2:	c3                   	ret    
801068b3:	90                   	nop
801068b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068b8:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801068bb:	31 c0                	xor    %eax,%eax
}
801068bd:	5b                   	pop    %ebx
801068be:	5e                   	pop    %esi
801068bf:	5f                   	pop    %edi
801068c0:	5d                   	pop    %ebp
801068c1:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801068c2:	c7 04 24 47 76 10 80 	movl   $0x80107647,(%esp)
801068c9:	e8 92 9a ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801068ce:	c7 04 24 e8 76 10 80 	movl   $0x801076e8,(%esp)
801068d5:	e8 86 9a ff ff       	call   80100360 <panic>
801068da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801068e0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	57                   	push   %edi
801068e4:	56                   	push   %esi
801068e5:	53                   	push   %ebx
801068e6:	83 ec 1c             	sub    $0x1c,%esp
801068e9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801068ec:	85 ff                	test   %edi,%edi
801068ee:	0f 88 7e 00 00 00    	js     80106972 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
801068f4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801068f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
801068fa:	72 78                	jb     80106974 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
801068fc:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106902:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106908:	39 df                	cmp    %ebx,%edi
8010690a:	77 4a                	ja     80106956 <allocuvm+0x76>
8010690c:	eb 72                	jmp    80106980 <allocuvm+0xa0>
8010690e:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106910:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106917:	00 
80106918:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010691f:	00 
80106920:	89 04 24             	mov    %eax,(%esp)
80106923:	e8 a8 da ff ff       	call   801043d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106928:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010692e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106933:	89 04 24             	mov    %eax,(%esp)
80106936:	8b 45 08             	mov    0x8(%ebp),%eax
80106939:	89 da                	mov    %ebx,%edx
8010693b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106942:	00 
80106943:	e8 48 fb ff ff       	call   80106490 <mappages>
80106948:	85 c0                	test   %eax,%eax
8010694a:	78 44                	js     80106990 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010694c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106952:	39 df                	cmp    %ebx,%edi
80106954:	76 2a                	jbe    80106980 <allocuvm+0xa0>
    mem = kalloc();
80106956:	e8 45 bb ff ff       	call   801024a0 <kalloc>
    if(mem == 0){
8010695b:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010695d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010695f:	75 af                	jne    80106910 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106961:	c7 04 24 65 76 10 80 	movl   $0x80107665,(%esp)
80106968:	e8 e3 9c ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010696d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106970:	77 48                	ja     801069ba <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106972:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106974:	83 c4 1c             	add    $0x1c,%esp
80106977:	5b                   	pop    %ebx
80106978:	5e                   	pop    %esi
80106979:	5f                   	pop    %edi
8010697a:	5d                   	pop    %ebp
8010697b:	c3                   	ret    
8010697c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106980:	83 c4 1c             	add    $0x1c,%esp
80106983:	89 f8                	mov    %edi,%eax
80106985:	5b                   	pop    %ebx
80106986:	5e                   	pop    %esi
80106987:	5f                   	pop    %edi
80106988:	5d                   	pop    %ebp
80106989:	c3                   	ret    
8010698a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106990:	c7 04 24 7d 76 10 80 	movl   $0x8010767d,(%esp)
80106997:	e8 b4 9c ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010699c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010699f:	76 0d                	jbe    801069ae <allocuvm+0xce>
801069a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801069a4:	89 fa                	mov    %edi,%edx
801069a6:	8b 45 08             	mov    0x8(%ebp),%eax
801069a9:	e8 62 fb ff ff       	call   80106510 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801069ae:	89 34 24             	mov    %esi,(%esp)
801069b1:	e8 3a b9 ff ff       	call   801022f0 <kfree>
      return 0;
801069b6:	31 c0                	xor    %eax,%eax
801069b8:	eb ba                	jmp    80106974 <allocuvm+0x94>
801069ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801069bd:	89 fa                	mov    %edi,%edx
801069bf:	8b 45 08             	mov    0x8(%ebp),%eax
801069c2:	e8 49 fb ff ff       	call   80106510 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801069c7:	31 c0                	xor    %eax,%eax
801069c9:	eb a9                	jmp    80106974 <allocuvm+0x94>
801069cb:	90                   	nop
801069cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069d0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801069d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801069d9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801069dc:	39 d1                	cmp    %edx,%ecx
801069de:	73 08                	jae    801069e8 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801069e0:	5d                   	pop    %ebp
801069e1:	e9 2a fb ff ff       	jmp    80106510 <deallocuvm.part.0>
801069e6:	66 90                	xchg   %ax,%ax
801069e8:	89 d0                	mov    %edx,%eax
801069ea:	5d                   	pop    %ebp
801069eb:	c3                   	ret    
801069ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069f0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	56                   	push   %esi
801069f4:	53                   	push   %ebx
801069f5:	83 ec 10             	sub    $0x10,%esp
801069f8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801069fb:	85 f6                	test   %esi,%esi
801069fd:	74 59                	je     80106a58 <freevm+0x68>
801069ff:	31 c9                	xor    %ecx,%ecx
80106a01:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106a06:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106a08:	31 db                	xor    %ebx,%ebx
80106a0a:	e8 01 fb ff ff       	call   80106510 <deallocuvm.part.0>
80106a0f:	eb 12                	jmp    80106a23 <freevm+0x33>
80106a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a18:	83 c3 01             	add    $0x1,%ebx
80106a1b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106a21:	74 27                	je     80106a4a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106a23:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106a26:	f6 c2 01             	test   $0x1,%dl
80106a29:	74 ed                	je     80106a18 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106a2b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106a31:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106a34:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106a3a:	89 14 24             	mov    %edx,(%esp)
80106a3d:	e8 ae b8 ff ff       	call   801022f0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106a42:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106a48:	75 d9                	jne    80106a23 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106a4a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106a4d:	83 c4 10             	add    $0x10,%esp
80106a50:	5b                   	pop    %ebx
80106a51:	5e                   	pop    %esi
80106a52:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106a53:	e9 98 b8 ff ff       	jmp    801022f0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106a58:	c7 04 24 99 76 10 80 	movl   $0x80107699,(%esp)
80106a5f:	e8 fc 98 ff ff       	call   80100360 <panic>
80106a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a70 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	56                   	push   %esi
80106a74:	53                   	push   %ebx
80106a75:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106a78:	e8 23 ba ff ff       	call   801024a0 <kalloc>
80106a7d:	85 c0                	test   %eax,%eax
80106a7f:	89 c6                	mov    %eax,%esi
80106a81:	74 6d                	je     80106af0 <setupkvm+0x80>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106a83:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a8a:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a8b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106a90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a97:	00 
80106a98:	89 04 24             	mov    %eax,(%esp)
80106a9b:	e8 30 d9 ff ff       	call   801043d0 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106aa0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106aa3:	8b 43 04             	mov    0x4(%ebx),%eax
80106aa6:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106aa9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106aad:	8b 13                	mov    (%ebx),%edx
80106aaf:	89 04 24             	mov    %eax,(%esp)
80106ab2:	29 c1                	sub    %eax,%ecx
80106ab4:	89 f0                	mov    %esi,%eax
80106ab6:	e8 d5 f9 ff ff       	call   80106490 <mappages>
80106abb:	85 c0                	test   %eax,%eax
80106abd:	78 19                	js     80106ad8 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106abf:	83 c3 10             	add    $0x10,%ebx
80106ac2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ac8:	72 d6                	jb     80106aa0 <setupkvm+0x30>
80106aca:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106acc:	83 c4 10             	add    $0x10,%esp
80106acf:	5b                   	pop    %ebx
80106ad0:	5e                   	pop    %esi
80106ad1:	5d                   	pop    %ebp
80106ad2:	c3                   	ret    
80106ad3:	90                   	nop
80106ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106ad8:	89 34 24             	mov    %esi,(%esp)
80106adb:	e8 10 ff ff ff       	call   801069f0 <freevm>
      return 0;
    }
  return pgdir;
}
80106ae0:	83 c4 10             	add    $0x10,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106ae3:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106ae5:	5b                   	pop    %ebx
80106ae6:	5e                   	pop    %esi
80106ae7:	5d                   	pop    %ebp
80106ae8:	c3                   	ret    
80106ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106af0:	31 c0                	xor    %eax,%eax
80106af2:	eb d8                	jmp    80106acc <setupkvm+0x5c>
80106af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b00 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106b06:	e8 65 ff ff ff       	call   80106a70 <setupkvm>
80106b0b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b10:	05 00 00 00 80       	add    $0x80000000,%eax
80106b15:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106b18:	c9                   	leave  
80106b19:	c3                   	ret    
80106b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b20 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106b20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b21:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106b23:	89 e5                	mov    %esp,%ebp
80106b25:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b2e:	e8 cd f8 ff ff       	call   80106400 <walkpgdir>
  if(pte == 0)
80106b33:	85 c0                	test   %eax,%eax
80106b35:	74 05                	je     80106b3c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106b37:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106b3a:	c9                   	leave  
80106b3b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106b3c:	c7 04 24 aa 76 10 80 	movl   $0x801076aa,(%esp)
80106b43:	e8 18 98 ff ff       	call   80100360 <panic>
80106b48:	90                   	nop
80106b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b50 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
80106b56:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106b59:	e8 12 ff ff ff       	call   80106a70 <setupkvm>
80106b5e:	85 c0                	test   %eax,%eax
80106b60:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b63:	0f 84 b9 00 00 00    	je     80106c22 <copyuvm+0xd2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b69:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b6c:	85 c0                	test   %eax,%eax
80106b6e:	0f 84 94 00 00 00    	je     80106c08 <copyuvm+0xb8>
80106b74:	31 ff                	xor    %edi,%edi
80106b76:	eb 48                	jmp    80106bc0 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106b78:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106b7e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b85:	00 
80106b86:	89 74 24 04          	mov    %esi,0x4(%esp)
80106b8a:	89 04 24             	mov    %eax,(%esp)
80106b8d:	e8 de d8 ff ff       	call   80104470 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b95:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b9a:	89 fa                	mov    %edi,%edx
80106b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ba0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ba6:	89 04 24             	mov    %eax,(%esp)
80106ba9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bac:	e8 df f8 ff ff       	call   80106490 <mappages>
80106bb1:	85 c0                	test   %eax,%eax
80106bb3:	78 63                	js     80106c18 <copyuvm+0xc8>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106bb5:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106bbb:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106bbe:	76 48                	jbe    80106c08 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bc3:	31 c9                	xor    %ecx,%ecx
80106bc5:	89 fa                	mov    %edi,%edx
80106bc7:	e8 34 f8 ff ff       	call   80106400 <walkpgdir>
80106bcc:	85 c0                	test   %eax,%eax
80106bce:	74 62                	je     80106c32 <copyuvm+0xe2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106bd0:	8b 00                	mov    (%eax),%eax
80106bd2:	a8 01                	test   $0x1,%al
80106bd4:	74 50                	je     80106c26 <copyuvm+0xd6>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106bd6:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80106bd8:	25 ff 0f 00 00       	and    $0xfff,%eax
80106bdd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106be0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106be6:	e8 b5 b8 ff ff       	call   801024a0 <kalloc>
80106beb:	85 c0                	test   %eax,%eax
80106bed:	89 c3                	mov    %eax,%ebx
80106bef:	75 87                	jne    80106b78 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80106bf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bf4:	89 04 24             	mov    %eax,(%esp)
80106bf7:	e8 f4 fd ff ff       	call   801069f0 <freevm>
  return 0;
80106bfc:	31 c0                	xor    %eax,%eax
}
80106bfe:	83 c4 2c             	add    $0x2c,%esp
80106c01:	5b                   	pop    %ebx
80106c02:	5e                   	pop    %esi
80106c03:	5f                   	pop    %edi
80106c04:	5d                   	pop    %ebp
80106c05:	c3                   	ret    
80106c06:	66 90                	xchg   %ax,%ax
80106c08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c0b:	83 c4 2c             	add    $0x2c,%esp
80106c0e:	5b                   	pop    %ebx
80106c0f:	5e                   	pop    %esi
80106c10:	5f                   	pop    %edi
80106c11:	5d                   	pop    %ebp
80106c12:	c3                   	ret    
80106c13:	90                   	nop
80106c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80106c18:	89 1c 24             	mov    %ebx,(%esp)
80106c1b:	e8 d0 b6 ff ff       	call   801022f0 <kfree>
      goto bad;
80106c20:	eb cf                	jmp    80106bf1 <copyuvm+0xa1>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106c22:	31 c0                	xor    %eax,%eax
80106c24:	eb d8                	jmp    80106bfe <copyuvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106c26:	c7 04 24 ce 76 10 80 	movl   $0x801076ce,(%esp)
80106c2d:	e8 2e 97 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106c32:	c7 04 24 b4 76 10 80 	movl   $0x801076b4,(%esp)
80106c39:	e8 22 97 ff ff       	call   80100360 <panic>
80106c3e:	66 90                	xchg   %ax,%ax

80106c40 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c40:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c41:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c43:	89 e5                	mov    %esp,%ebp
80106c45:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c48:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c4e:	e8 ad f7 ff ff       	call   80106400 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106c53:	8b 00                	mov    (%eax),%eax
80106c55:	89 c2                	mov    %eax,%edx
80106c57:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106c5a:	83 fa 05             	cmp    $0x5,%edx
80106c5d:	75 11                	jne    80106c70 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106c5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c64:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106c69:	c9                   	leave  
80106c6a:	c3                   	ret    
80106c6b:	90                   	nop
80106c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106c70:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106c72:	c9                   	leave  
80106c73:	c3                   	ret    
80106c74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c80 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 1c             	sub    $0x1c,%esp
80106c89:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106c92:	85 db                	test   %ebx,%ebx
80106c94:	75 3a                	jne    80106cd0 <copyout+0x50>
80106c96:	eb 68                	jmp    80106d00 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106c98:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c9b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106c9d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106ca1:	29 ca                	sub    %ecx,%edx
80106ca3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106ca9:	39 da                	cmp    %ebx,%edx
80106cab:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106cae:	29 f1                	sub    %esi,%ecx
80106cb0:	01 c8                	add    %ecx,%eax
80106cb2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106cb6:	89 04 24             	mov    %eax,(%esp)
80106cb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106cbc:	e8 af d7 ff ff       	call   80104470 <memmove>
    len -= n;
    buf += n;
80106cc1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106cc4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106cca:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ccc:	29 d3                	sub    %edx,%ebx
80106cce:	74 30                	je     80106d00 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106cd3:	89 ce                	mov    %ecx,%esi
80106cd5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106cdb:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106cdf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106ce2:	89 04 24             	mov    %eax,(%esp)
80106ce5:	e8 56 ff ff ff       	call   80106c40 <uva2ka>
    if(pa0 == 0)
80106cea:	85 c0                	test   %eax,%eax
80106cec:	75 aa                	jne    80106c98 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106cee:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106cf6:	5b                   	pop    %ebx
80106cf7:	5e                   	pop    %esi
80106cf8:	5f                   	pop    %edi
80106cf9:	5d                   	pop    %ebp
80106cfa:	c3                   	ret    
80106cfb:	90                   	nop
80106cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d00:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106d03:	31 c0                	xor    %eax,%eax
}
80106d05:	5b                   	pop    %ebx
80106d06:	5e                   	pop    %esi
80106d07:	5f                   	pop    %edi
80106d08:	5d                   	pop    %ebp
80106d09:	c3                   	ret    
