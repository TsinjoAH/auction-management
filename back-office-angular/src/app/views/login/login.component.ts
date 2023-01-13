import {Component, EventEmitter, Input, OnInit, Output, ViewChild} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {ToasterComponent, ToasterPlacement} from "@coreui/angular";
import {ToastSampleComponent} from "./toast-sample/toast-sample.component";

// export class LoginData {
//     constructor(
//         public title: string,
//         public callBack: (service: LoginService, data: any) => any
//     ) {
//     }
// }

@Component({
    selector: 'app-login',
    templateUrl: './login.component.html',
    styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

    placement = ToasterPlacement.MiddleCenter;
    @ViewChild(ToasterComponent) toaster !: ToasterComponent;
    // @ViewChild('connectionSwal') swal!: SwalComponent
    loginForm !: FormGroup;

    constructor(private formBuilder: FormBuilder) {
    }

    ngOnInit(): void {
        this.loginForm = this.formBuilder.group({
            email: ['', Validators.required],
            password: ['', Validators.required],
        });
    }

    onSubmit() {
        if (this.loginForm.valid) {
          console.log(this.loginForm.value);
            // this.consume.callBack(this.loginService, this.loginForm.value).subscribe({
            //     next: (data: {data: any}) => this.successData.emit(data.data),
            //     error: (e: any) => {
            //         let err = e.error as { code: number, message: string };
            //         this.invokeToast("Erreur", "danger", err.message);
            //     }
            // });
        }
    }

    invokeToast(title: any, color: any, message: any) {
        // this.swal.fire();
        const options = {
            placement: this.placement,
            delay: 2000,
            color: color,
            title: title,
            autohide: true,
            message: message
        };
        const toastRef = this.toaster.addToast(ToastSampleComponent, {...options});
    }

}
