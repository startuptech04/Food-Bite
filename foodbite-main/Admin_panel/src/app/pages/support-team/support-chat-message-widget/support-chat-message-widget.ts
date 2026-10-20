import { Location } from '@angular/common';
import { Component, OnDestroy, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { DateTime } from 'luxon';
import { NgScrollbar } from 'ngx-scrollbar';
import { Subscription } from 'rxjs';
import { SupportTeamChatMessageInteface } from 'src/app/interfaces/support.team.chat.message.interface';
import { ApiService } from 'src/app/services/api-service';
import { ChatService } from 'src/app/services/chat-service';
import { UtilService } from 'src/app/services/util-service';
import { ConfirmDialog } from 'src/app/ui-components/confirm-dialog/confirm-dialog';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MaterialModule } from 'src/app/material.module';
import { NgScrollbarModule } from 'ngx-scrollbar';

@Component({
  selector: 'app-support-chat-message-widget',
  imports: [CommonModule, FormsModule, ReactiveFormsModule, MaterialModule, NgScrollbarModule],
  templateUrl: './support-chat-message-widget.html',
})
export class SupportChatMessageWidget implements OnDestroy {

  @ViewChild('chatMessageScroll') chatMessageScroll!: NgScrollbar;
  sidePanelOpened = true;
  uid: string = '';
  roomId: string = '';
  chatMessages: SupportTeamChatMessageInteface[] = [];
  private messageSubscription!: Subscription;
  msg: string = '';
  isChatMessageLoaded: boolean = false;
  supportFor: string = '';
  supportForId: string = '';
  supportStarted: string = '';
  userId: string = '';
  userFirstName: string = '';
  userLastName: string = '';
  userImage: string = '';
  userRole: string = '';
  userMobile: string = '';
  userEmail: string = '';
  supportTeamFirstName: string = '';
  supportTeamLastName: string = '';
  supportTeamImage: string = '';
  haveRestaurantInfo: boolean = false;
  restaurantName: string = '';
  restaurantAddress: string = '';
  restaurantImage: string = '';
  restaurantOwnerName: string = '';
  restaurantOwnerEmail: string = '';
  restaurantOwnerPhone: string = '';
  restaurantOwnerType: string = '';
  orderNo: number = 0;
  orderGrandTotal: number = 0;
  orderType: string = '';
  orderStatus: string = 'created';
  bookingId: string = '';
  bookingGrandTotal: number = 0;
  bookingStatus: string = 'created';
  packageId: string = '';
  packageGrandTotal: number = 0;
  packageStatus: string = 'created';
  complaintId: string = '';
  complaintTitle: string = '';
  complaintBrief: string = '';
  complaintIssueWith: string = '';
  complaintReason: string = '';
  reportId: string = '';
  reportMessage: string = '';
  reportReason: string = '';
  loadMoreChats: boolean = false;
  pageSize: number = 10;
  currentPage: number = 0;
  totalResults: number = 0;
  serverResults: number = 0;

  constructor(
    public api: ApiService,
    public util: UtilService,
    private chatService: ChatService,
    private route: ActivatedRoute,
    private location: Location,
    private router: Router,
    private dialog: MatDialog,
  ) {
    this.uid = this.util.getItem('_uid');
    this.roomId = this.route.snapshot.paramMap.get('id') ?? '';
    if (this.roomId != '') {
      this.getInitialDetail();
    } else {
      this.util.onError('ts_something_went_wrong', '');
    }
  }

  getInitialDetail() {
    console.log('Get Detail');
    const param: any = {
      'roomId': this.roomId,
      'supportTeam': this.uid,
      'limit': this.pageSize,
      'page': this.currentPage,
    };

    this.api.post_private('v1/support_team/chat_message_initial/', param).subscribe({
      next: (response: any) => {
        this.isChatMessageLoaded = true;
        console.log(response);
        if (response && response.success) {
          const detail = response.chats;
          const info = response.info;
          if (info && info._id && info._id != '') {
            this.supportFor = info.supportType;
            this.supportStarted = DateTime.fromISO(info.createdAt).setLocale(this.util.appLocaleName()).toFormat('MMM dd, yyyy hh:mm a');
            console.log(this.supportStarted);
            if (this.supportFor == 'orders') {
              this.supportForId = info.orders;
            } else if (this.supportFor == 'dining') {
              this.supportForId = info.booking;
            } else if (this.supportFor == 'tiffin_subscription') {
              this.supportForId = info.purchaseSubscription;
            } else if (this.supportFor == 'complaints') {
              this.supportForId = info.complaints;
            } else if (this.supportFor == 'reports') {
              this.supportForId = info.reportIssue;
            } else if (this.supportFor == 'restaurant_complaints') {
              this.supportForId = info.restaurantComplaints;
            }
          }

          const orderInfo = response.orderInfo;
          if (orderInfo && orderInfo != null && orderInfo.id && orderInfo.id != null && orderInfo.id != '') {
            this.orderNo = orderInfo.orderNo;
            this.orderGrandTotal = orderInfo.grandTotal;
            this.orderStatus = orderInfo.status;
            this.orderType = orderInfo.orderTo == 'homedelivery' ? this.util.appTranslate('home_delivery') : this.util.appTranslate('takeaway');
          }

          const bookingInfo = response.bookingInfo;
          if (bookingInfo && bookingInfo != null && bookingInfo.id && bookingInfo.id != null && bookingInfo.id != '') {
            this.bookingId = bookingInfo.id;
            this.bookingGrandTotal = bookingInfo.grandTotal;
            this.bookingStatus = bookingInfo.status;
          }

          const packageInfo = response.packageInfo;
          if (packageInfo && packageInfo != null && packageInfo.id && packageInfo.id != null && packageInfo.id != '') {
            this.packageId = packageInfo.id;
            this.packageGrandTotal = packageInfo.grandTotal;
            this.packageStatus = packageInfo.status;
          }

          const complaintInfo = response.complaintInfo;
          if (complaintInfo && complaintInfo != null && complaintInfo.id && complaintInfo.id != null && complaintInfo.id != '') {
            this.complaintId = complaintInfo.id;
            this.complaintTitle = complaintInfo.title;
            this.complaintBrief = complaintInfo.brief;
            this.complaintIssueWith = complaintInfo.issueWith;
            if (complaintInfo && complaintInfo.reasons && complaintInfo.reasons.id && complaintInfo.reasons.id != '') {
              this.complaintReason = complaintInfo.reasons.name;
              if (complaintInfo && complaintInfo.reasons && complaintInfo.reasons.translations && Array.isArray(complaintInfo.reasons.translations)) {
                if (complaintInfo.reasons.translations) {
                  const translation = complaintInfo.reasons.translations.find((t: any) => t.code == this.util.appLocaleName());
                  this.complaintReason = translation?.value || complaintInfo.reasons.name;
                }
              }
            }
          }

          const restaurantComplaintInfo = response.restaurantComplaintInfo;
          if (restaurantComplaintInfo && restaurantComplaintInfo != null && restaurantComplaintInfo.id && restaurantComplaintInfo.id != null && restaurantComplaintInfo.id != '') {
            this.complaintId = restaurantComplaintInfo.id;
            this.complaintTitle = restaurantComplaintInfo.title;
            this.complaintBrief = restaurantComplaintInfo.brief;
            this.complaintIssueWith = restaurantComplaintInfo.issueWith;
            if (restaurantComplaintInfo && restaurantComplaintInfo.reasons && restaurantComplaintInfo.reasons.id && restaurantComplaintInfo.reasons.id != '') {
              this.complaintReason = restaurantComplaintInfo.reasons.name;
              if (restaurantComplaintInfo && restaurantComplaintInfo.reasons && restaurantComplaintInfo.reasons.translations && Array.isArray(restaurantComplaintInfo.reasons.translations)) {
                if (restaurantComplaintInfo.reasons.translations) {
                  const translation = restaurantComplaintInfo.reasons.translations.find((t: any) => t.code == this.util.appLocaleName());
                  this.complaintReason = translation?.value || restaurantComplaintInfo.reasons.name;
                }
              }
            }
          }

          const reportInfo = response.reportInfo;
          if (reportInfo && reportInfo != null && reportInfo.id && reportInfo.id != null && reportInfo.id != '') {
            this.reportId = reportInfo.id;
            this.reportMessage = reportInfo.message;
            if (reportInfo && reportInfo.reasons && reportInfo.reasons.id && reportInfo.reasons.id != '') {
              this.reportReason = reportInfo.reasons.name;
              if (reportInfo && reportInfo.reasons && reportInfo.reasons.translations && Array.isArray(reportInfo.reasons.translations)) {
                if (reportInfo.reasons.translations) {
                  const translation = reportInfo.reasons.translations.find((t: any) => t.code == this.util.appLocaleName());
                  this.reportReason = translation?.value || reportInfo.reasons.name;
                }
              }
            }
          }

          const userInfo = response.userInfo;
          if (userInfo && userInfo.id && userInfo.id != '') {
            this.userId = userInfo.id;
            this.userEmail = userInfo.email;
            this.userFirstName = userInfo.firstName;
            this.userLastName = userInfo.lastName;
            this.userRole = userInfo.role;
            this.userImage = userInfo.image;
            this.userMobile = `+${userInfo.countryCode} ${userInfo.mobile}`;
          }
          const supportTeam = response.supportTeam;
          if (supportTeam && supportTeam.id && supportTeam.id != '') {
            this.supportTeamFirstName = supportTeam.firstName;
            this.supportTeamLastName = supportTeam.lastName;
            this.supportTeamImage = supportTeam.image;
          }

          const restaurantInfo = response.restaurantInfo;
          if (restaurantInfo && restaurantInfo != null && restaurantInfo.id != null && restaurantInfo.id != '') {
            this.haveRestaurantInfo = true;
            this.restaurantName = restaurantInfo.name;
            this.restaurantAddress = restaurantInfo.address;
            this.restaurantImage = restaurantInfo.cover;
            const userDetail = restaurantInfo.userInfo;
            if (userDetail && userDetail != null && userDetail.id != null && userDetail.id != '') {
              this.restaurantOwnerName = `${userDetail.firstName} ${userDetail.lastName}`;
              this.restaurantOwnerEmail = userDetail.email;
              this.restaurantOwnerPhone = `+${userDetail.countryCode} ${userDetail.mobile}`;
              this.restaurantOwnerType = userDetail.role;
            }

            if (response && response.restaurantInfo && response.restaurantInfo?.translations && Array.isArray(response.restaurantInfo?.translations)) {
              const translation = response.restaurantInfo.translations.find((t: any) => t.code == this.util.appLocaleName());
              this.restaurantName = translation?.title || response.restaurantInfo.name;
              this.restaurantAddress = translation?.address || response.restaurantInfo.address;
            }
          }

          this.chatMessages = detail.chats;
          this.chatMessages = this.chatMessages.sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime());
          this.totalResults = detail.totalResults;
          this.serverResults = detail.chats.length;
          setTimeout(() => {
            this.scrollToBottom();
          }, 2);
          if (this.messageSubscription) {
            this.messageSubscription.unsubscribe();
            this.chatService.disconnect();
          }
          this.chatService.connectToServer(this.roomId);
          this.messageSubscription = this.chatService.receiveMessage().subscribe((data: any) => {
            console.log('Message received: ', data);
            const param = {
              "roomId": this.roomId,
              "senderId": data.senderId,
              "message": data.message,
              "messageType": data.messageType,
              "createdAt": data.currentDate,
              "id": data.randomId,
              'sender': {
                'id': data.senderId,
                'image': data && data.senderCover && data.senderCover != null && data.senderCover != '' ? data.senderCover : '',
                'firstName': data && data.senderFirstName && data.senderFirstName != null && data.senderFirstName != '' ? data.senderFirstName : '',
                'lastName': data && data.senderLastName && data.senderLastName != null && data.senderLastName != '' ? data.senderLastName : '',
                'role': data.role
              }
            };
            if (param.senderId != this.uid) {
              this.chatMessages.push(param);
            }
            this.scrollToBottom();
          });
        }
      }, error: (error: any) => {
        console.log(error);
        this.isChatMessageLoaded = true;
        this.util.handleError(error, 'support-team');
      }
    });
  }

  getStatusColor(orderStatus: string) {
    const okOrderStatus = ['created', 'accepted', 'preparing'];
    const successOrderStatus = ['delivered', 'ready', 'handover', 'ongoing'];
    const failedOrderStatus = ['cancelled', 'rejected', 'refunded', 'partially_refunded', 'pending_payments'];
    if (okOrderStatus.includes(orderStatus)) {
      return 'primary';
    } else if (successOrderStatus.includes(orderStatus)) {
      return 'success';
    } else if (failedOrderStatus.includes(orderStatus)) {
      return 'error';
    }
    return 'warning';
  }

  onBack() {
    this.location.back();
  }

  isOver(): boolean {
    return window.matchMedia(`(max-width: 960px)`).matches;
  }

  ngOnDestroy() {
    console.log('destroy');
    if (this.messageSubscription) {
      this.messageSubscription.unsubscribe();
    }
    this.chatService.disconnect();
  }

  ngAfterViewInit() {
    const viewport = this.chatMessageScroll.nativeElement;
    viewport.addEventListener('scrollend', () => {
      if (viewport.scrollTop <= 0) {
        this.loadMoreChatMessage();
      }
    }, { passive: true });
  }

  loadMoreChatMessage() {
    console.log('Load More Chat Messages...');
    if (this.serverResults < this.totalResults) {
      console.log('Fetch More.........');
      this.loadMoreChats = true;
      this.pageSize = Number(this.pageSize) * 2;
      const param: any = {
        'roomId': this.roomId,
        'supportTeam': this.uid,
        'limit': this.pageSize,
        'page': this.currentPage,
      };
      this.api.post_private('v1/support_team/fetche_more_result/', param).subscribe({
        next: (response: any) => {
          this.loadMoreChats = false;
          console.log(response);
          if (response && response.success) {
            const detail = response.chats;
            this.chatMessages = detail.chats;
            this.chatMessages = this.chatMessages.sort((a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime());
            this.totalResults = detail.totalResults;
            this.serverResults = detail.chats.length;
          }
        }, error: (error: any) => {
          console.log(error);
          this.loadMoreChats = false;
          this.util.handleError(error, 'support-team');
        }
      });
    }
  }

  scrollToBottom(): void {
    try {
      const element = document.getElementById('chatBox');
      if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'end', inline: 'nearest' });
      }
    } catch (err) {
      console.error('Scrolling failed:', err);
    }
  }

  sendMessage() {
    console.log(`send message --> ${this.msg}`);
    const randomId = Date.now().toString();
    this.chatService.sendMessage(this.roomId, this.uid, this.msg, randomId, this.supportTeamFirstName, this.supportTeamLastName, this.supportTeamImage);
    const param = {
      "roomId": this.roomId,
      "senderId": this.uid,
      "message": this.msg,
      "messageType": 'text',
      "createdAt": DateTime.now().toISO(),
      "id": randomId,
      'sender': {
        'id': this.uid,
        'image': this.supportTeamImage,
        'firstName': this.supportTeamFirstName,
        'lastName': this.supportTeamLastName,
        'role': localStorage.getItem('_authRole') || '',
      }
    };
    this.chatMessages.push(param);
    this.scrollToBottom();
    const serverParam = {
      'room': this.roomId,
      'sender': this.uid,
      'msg': this.msg,
      'msgType': 'text'
    }
    this.msg = '';
    this.api.post_private('v1/support_team/chat/send/', serverParam).subscribe({
      next: (response: any) => {
        console.log(response);
      }, error: (error: any) => {
        console.log(error);
        this.util.handleError(error, 'support-team');
      }
    });
  }

  onScroll(event: any) {
    console.log('scroll---', event);
  }

  getDateFormatted(date: string) {
    return DateTime.fromISO(date).setLocale(this.util.appLocaleName()).toFormat('LLL dd, yyyy');
  }

  getBookingStatusColor(bookingStatus: string) {
    const okBookingStatus = ['created', 'accepted', 'preparing'];
    const successBookingStatus = ['completed'];
    const failedBookingStatus = ['cancelled', 'rejected', 'refunded', 'partially_refunded', 'pending_payments'];
    if (okBookingStatus.includes(bookingStatus)) {
      return 'primary';
    } else if (successBookingStatus.includes(bookingStatus)) {
      return 'success';
    } else if (failedBookingStatus.includes(bookingStatus)) {
      return 'error';
    }
    return 'warning';
  }

  getPackageStatusColor(orderStatus: string) {
    const okOrderStatus = ['created'];
    const successOrderStatus = ['completed'];
    const failedOrderStatus = ['cancelled', 'refunded', 'partially_refunded', 'pending_payments'];
    if (okOrderStatus.includes(orderStatus)) {
      return 'primary';
    } else if (successOrderStatus.includes(orderStatus)) {
      return 'success';
    } else if (failedOrderStatus.includes(orderStatus)) {
      return 'error';
    }
    return 'warning';
  }

  onOrderDetail() {
    this.router.navigate(['support-team/u/order-detail', this.supportForId]);
  }

  onBookingDetail() {
    this.router.navigate(['support-team/u/dining-booking', this.supportForId]);
  }

  onTiffinPurchaseDetail() {
    this.router.navigate(['support-team/u/tiffin-purchase-detail', this.supportForId]);
  }

  resolveSupportChat() {
    console.log(`Resolve Chat ${this.roomId}`);
    const dialogRef = this.dialog.open(ConfirmDialog, {
      data: { title: 'ts_mark_chat_resolved', subTitle: 'ts_mark_chat_resolved_instruction', okTitle: 'ts_resolved_chat', closeTitle: 'ts_cancel' },
      disableClose: true
    });
    dialogRef.afterClosed().subscribe((result) => {
      console.log(result);
      if (result && result.action && result.action == "confirm") {
        console.log('confirmed');
        const param = {
          'id': this.roomId,
          'team': this.uid,
        }
        const spinnerRef = this.util.start();
        this.api.post_private('v1/support_team/resolve_support_chat/', param).subscribe({
          next: (response: any) => {
            console.log(response);
            this.util.stop(spinnerRef);
            this.onBack();
          }, error: (error: any) => {
            console.log(error);
            this.util.stop(spinnerRef);
            this.util.handleError(error, 'support-team');
          }
        });
      }
    });
  }

  exportSupportChat() {
    console.log('export');
    const spinnerRef = this.util.start();
    this.api.get_private('v1/support_team/export_chats/' + this.roomId).subscribe({
      next: (response: any) => {
        console.log(response);
        this.util.stop(spinnerRef);
        this.util.onSuccess('ts_exported');
      }, error: (error: any) => {
        console.log(error);
        this.util.stop(spinnerRef);
        this.util.handleError(error, 'support-team');
      }
    });
  }

}
