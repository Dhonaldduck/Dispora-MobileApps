import { User } from '../../users/entities/user.entity';
export declare class News {
    id: string;
    title: string;
    slug: string;
    content: string;
    thumbnailUrl: string;
    authorId: string;
    author: User;
    isPublished: boolean;
    createdAt: Date;
    updatedAt: Date;
}
