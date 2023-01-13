import {ChangeDetectorRef, Component, ElementRef, forwardRef, Input, Renderer2} from '@angular/core';
import {ToastComponent, ToasterService} from "@coreui/angular";

@Component({
    selector: 'app-toast-sample',
    templateUrl: './toast-sample.component.html',
    styleUrls: ['./toast-sample.component.scss'],
    providers: [{provide: ToastComponent, useExisting: forwardRef(() => ToastSampleComponent)}]
})

export class ToastSampleComponent extends ToastComponent {
    @Input() closeButton = true;
    @Input() title = '';
    @Input() message = '';

    constructor(
        public override hostElement: ElementRef,
        public override renderer: Renderer2,
        public override toasterService: ToasterService,
        public override changeDetectorRef: ChangeDetectorRef
    ) {
        super(hostElement, renderer, toasterService, changeDetectorRef);
    }


}
