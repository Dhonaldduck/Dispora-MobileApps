import { User } from '../../users/entities/user.entity';
export declare class Agenda {
    id: string;
    title: string;
    slug: string;
    description: string;
    location: string;
    startDate: Date;
    endDate: Date;
    thumbnailUrl: string;
    authorId: string;
    author: User;
    isPublished: boolean;
    createdAt: Date;
    updatedAt: Date;
}
