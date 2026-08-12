import { User } from '../../users/entities/user.entity';
export declare class YouthService {
    id: string;
    title: string;
    slug: string;
    description: string;
    category: string;
    thumbnailUrl: string;
    registrationLink: string;
    authorId: string;
    author: User;
    isPublished: boolean;
    createdAt: Date;
    updatedAt: Date;
}
