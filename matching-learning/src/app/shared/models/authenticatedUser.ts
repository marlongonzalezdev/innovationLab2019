import { MessageService } from './../../../message.service';
export interface AuthenticatedUser {
    authenticated: boolean;
    message: string;
}
